import Foundation

final class AchievementEngine {

    static func compute(records: [CupRecord], drinks: [Drink]) -> [AchievementGroupData] {
        let uniqueDrinks = Set(records.map { $0.drinkID })
        let drinkCounts: [String: Int] = records.reduce(into: [:]) { $0[$1.drinkID, default: 0] += 1 }
        let maxSingleCount = drinkCounts.values.max() ?? 0
        let total = records.count

        func inCategory(_ cat: DrinkCategory) -> Set<String> {
            Set(drinks.filter { $0.category == cat }.map { $0.id })
        }
        func inSubCategory(_ sub: String) -> Set<String> {
            Set(drinks.filter { $0.subCategory == sub }.map { $0.id })
        }
        func inBrand(_ brand: BrandType) -> Set<String> {
            Set(drinks.filter { $0.brand == brand }.map { $0.id })
        }

        let starbucksSet = inBrand(.starbucks)
        let mannerSet    = inBrand(.manner)
        let starbucksUnlocked = uniqueDrinks.intersection(starbucksSet).count
        let mannerUnlocked    = uniqueDrinks.intersection(mannerSet).count

        let collectionBadges: [Achievement] = [
            .init(id: "col-sb-10",  group: .collection, name: "星巴克初尝", desc: "解锁星巴克 10 款",
                  target: 10, progress: starbucksUnlocked, badgeKind: "starter"),
            .init(id: "col-sb-all", group: .collection, name: "星巴克全鉴", desc: "解锁全部星巴克 \(starbucksSet.count) 款",
                  target: max(1, starbucksSet.count), progress: starbucksUnlocked, badgeKind: "full"),
            .init(id: "col-mn-10",  group: .collection, name: "Manner 初尝", desc: "解锁 Manner 10 款",
                  target: 10, progress: mannerUnlocked, badgeKind: "starter"),
            .init(id: "col-mn-all", group: .collection, name: "Manner 全鉴", desc: "解锁全部 Manner \(mannerSet.count) 款",
                  target: max(1, mannerSet.count), progress: mannerUnlocked, badgeKind: "full"),
        ]

        let classicSet = inSubCategory("经典咖啡")
        let frapSet    = inCategory(.frappuccino)
        let ventiSet   = inCategory(.mnVenti)
        let mnClassicSet = inCategory(.mnClassicEspresso)

        let typeBadges: [Achievement] = [
            .init(id: "type-coffee",   group: .typeMaster, name: "经典咖啡通关", desc: "喝过全部星巴克经典咖啡",
                  target: max(1, classicSet.count), progress: uniqueDrinks.intersection(classicSet).count, badgeKind: "classicMaster"),
            .init(id: "type-frap",     group: .typeMaster, name: "星冰乐通关",   desc: "喝过全部星冰乐",
                  target: max(1, frapSet.count), progress: uniqueDrinks.intersection(frapSet).count, badgeKind: "frapMaster"),
            .init(id: "type-mn-venti", group: .typeMaster, name: "Manner 超大杯", desc: "喝过全部 Manner 超大杯",
                  target: max(1, ventiSet.count), progress: uniqueDrinks.intersection(ventiSet).count, badgeKind: "teaMaster"),
            .init(id: "type-mn-classic", group: .typeMaster, name: "Manner 经典意式", desc: "喝过全部 Manner 经典意式",
                  target: max(1, mnClassicSet.count), progress: uniqueDrinks.intersection(mnClassicSet).count, badgeKind: "classicMaster"),
        ]

        let fanBadges: [Achievement] = [
            .init(id: "fan-10",   group: .singleFan, name: "一见钟情", desc: "同款喝 ≥10 次",
                  target: 10, progress: maxSingleCount, badgeKind: "fan10"),
            .init(id: "fan-50",   group: .singleFan, name: "老情人",   desc: "同款喝 ≥50 次",
                  target: 50, progress: maxSingleCount, badgeKind: "fan50"),
            .init(id: "fan-100",  group: .singleFan, name: "此生挚爱", desc: "同款喝 ≥100 次",
                  target: 100, progress: maxSingleCount, badgeKind: "fan100"),
            .init(id: "fan-week", group: .singleFan, name: "专一",     desc: "连续一周只喝一款",
                  target: 7, progress: weeklyMonoDays(records: records), badgeKind: "fan10"),
        ]

        let milestoneBadges: [Achievement] = [
            .init(id: "mile-100",  group: .milestone, name: "100 杯",  desc: "累计 ≥100 杯",
                  target: 100, progress: total, badgeKind: "starter"),
            .init(id: "mile-200",  group: .milestone, name: "200 杯",  desc: "累计 ≥200 杯",
                  target: 200, progress: total, badgeKind: "cup100"),
            .init(id: "mile-500",  group: .milestone, name: "500 杯",  desc: "累计 ≥500 杯",
                  target: 500, progress: total, badgeKind: "cup500"),
            .init(id: "mile-1000", group: .milestone, name: "1000 杯", desc: "累计 ≥1000 杯",
                  target: 1000, progress: total, badgeKind: "cup500"),
        ]

        return [
            AchievementGroupData(group: .collection, badges: collectionBadges),
            AchievementGroupData(group: .typeMaster,  badges: typeBadges),
            AchievementGroupData(group: .singleFan,   badges: fanBadges),
            AchievementGroupData(group: .milestone,   badges: milestoneBadges),
        ]
    }

    static func level(totalCups: Int) -> Int {
        Int(sqrt(Double(totalCups) / 4.0))
    }

    static func cupsForNextLevel(totalCups: Int) -> Int {
        let lv = level(totalCups: totalCups)
        return (lv + 1) * (lv + 1) * 4 - totalCups
    }

    static func levelProgress(totalCups: Int) -> Double {
        let lv = level(totalCups: totalCups)
        let current = lv * lv * 4
        let next    = (lv + 1) * (lv + 1) * 4
        guard next > current else { return 1 }
        return Double(totalCups - current) / Double(next - current)
    }

    static func joinDays(records: [CupRecord]) -> Int {
        guard let first = records.min(by: { $0.drunkAt < $1.drunkAt }) else { return 0 }
        return Calendar.current.dateComponents([.day], from: first.drunkAt, to: Date()).day ?? 0
    }

    static func streak(records: [CupRecord]) -> Int {
        let cal = Calendar.current
        let days = Set(records.map { cal.startOfDay(for: $0.drunkAt) })
        var streak = 0
        var day = cal.startOfDay(for: Date())
        while days.contains(day) {
            streak += 1
            day = cal.date(byAdding: .day, value: -1, to: day)!
        }
        return streak
    }

    private static func weeklyMonoDays(records: [CupRecord]) -> Int {
        let cal = Calendar.current
        let weekStart = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
        let weekRecords = records.filter { $0.drunkAt >= weekStart }
        let weekDays = Set(weekRecords.map { cal.startOfDay(for: $0.drunkAt) })

        if !weekRecords.isEmpty {
            let firstID = weekRecords.first!.drinkID
            if weekRecords.allSatisfy({ $0.drinkID == firstID }) {
                return weekDays.count
            }
        }
        return 0
    }
}

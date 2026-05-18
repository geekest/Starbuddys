import Foundation

final class BrewRecommender {

    static func recommend(from drinks: [Drink], records: [CupRecord]) -> Drink? {
        guard !drinks.isEmpty else { return nil }

        let hour  = Calendar.current.component(.hour, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let drinkCounts: [String: Int] = records.reduce(into: [:]) { $0[$1.drinkID, default: 0] += 1 }
        let recentIDs = Set(records.prefix(5).map { $0.drinkID })
        let isColdSeason = month >= 11 || month <= 3

        var candidates = drinks.filter { !$0.sizePrices.isEmpty }
        if candidates.isEmpty { candidates = drinks }

        func weight(for drink: Drink) -> Double {
            var w = 1.0
            let count = drinkCounts[drink.id] ?? 0

            if count == 0 { w *= 2.0 }

            switch hour {
            case 5..<11:
                if drink.tags.contains(.latte) || drink.tags.contains(.americano) { w *= 1.5 }
            case 14..<18:
                if drink.category.isFrappuccino || drink.tags.contains(.cold) { w *= 1.5 }
            case 18...:
                if drink.category.isTeaDrink || drink.tags.contains(.noAddedSugar) { w *= 1.5 }
            default:
                break
            }

            if isColdSeason && drink.tags.contains(.hot)  { w *= 1.3 }
            if !isColdSeason && drink.tags.contains(.cold) { w *= 1.3 }
            if recentIDs.contains(drink.id) { w *= 0.3 }

            return max(0.1, w)
        }

        let weights = candidates.map { weight(for: $0) }
        let total = weights.reduce(0, +)
        var r = Double.random(in: 0..<max(total, 0.01))

        for (drink, w) in zip(candidates, weights) {
            r -= w
            if r <= 0 { return drink }
        }
        return candidates.randomElement()
    }

    static func defaultConfig(for drink: Drink) -> (CupSize, Temperature, SugarLevel) {
        (recommendSize(for: drink), drink.defaultTemperature, recommendSugar(for: drink))
    }

    private static func recommendSize(for drink: Drink) -> CupSize {
        let prices = drink.sizePrices
        // 美式/纯黑咖啡：中杯更能体现咖啡风味，不被水稀释
        if drink.tags.contains(.americano) {
            if prices[.tall] != nil { return .tall }
        }
        // 单品SOE：中杯品味更集中
        if drink.category == .mnSOE {
            if prices[.tall] != nil { return .tall }
        }
        // 茶饮/无咖啡系列：中杯轻盈感更好
        if drink.category.isTeaDrink || drink.category == .mnNonCoffee {
            if prices[.tall] != nil { return .tall }
        }
        return drink.defaultSize
    }

    private static func recommendSugar(for drink: Drink) -> SugarLevel {
        // 美式/黑咖啡：无糖，保留咖啡本味
        if drink.tags.contains(.americano) { return .none }

        // 单品SOE：无糖，品鉴咖啡豆风土
        if drink.category == .mnSOE { return .none }

        // 标注无额外加糖的产品
        if drink.tags.contains(.noAddedSugar) { return .none }

        // 抹茶：自带苦味，半糖平衡
        if drink.tags.contains(.matcha) { return .half }

        // 茶饮系列：清雅，少糖即可
        if drink.category.isTeaDrink || drink.tags.contains(.tea) { return .less }

        // 花香类：细腻风味适合少糖
        if drink.tags.contains(.floral) { return .less }

        // 拿铁：牛奶本身有甜感，少糖
        if drink.tags.contains(.latte) { return .less }

        // Manner经典意式（卡布、小白等）：微糖提升层次
        if drink.category == .mnClassicEspresso { return .micro }

        // 星冰乐/焦糖/巧克力/香草/Refreshers：本身甜度足，标准
        return .standard
    }
}

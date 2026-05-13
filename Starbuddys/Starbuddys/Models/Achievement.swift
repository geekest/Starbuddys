import Foundation

struct Achievement: Identifiable {
    let id: String
    let group: AchievementGroup
    let name: String
    let desc: String
    let target: Int
    let progress: Int
    let badgeKind: String

    var isUnlocked: Bool { progress >= target }
    var progressFraction: Double { min(1.0, Double(progress) / Double(max(1, target))) }
}

struct AchievementGroupData: Identifiable {
    let group: AchievementGroup
    let badges: [Achievement]

    var id: String { group.rawValue }
    var title: String { group.rawValue }

    var subtitle: String {
        let unlocked = badges.filter { $0.isUnlocked }.count
        return "已解锁 \(unlocked) / \(badges.count) 项"
    }

    var groupProgress: Double {
        let unlocked = badges.filter { $0.isUnlocked }.count
        return Double(unlocked) / Double(max(1, badges.count))
    }
}

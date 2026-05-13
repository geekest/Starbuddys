import SwiftUI
import SwiftData

struct ProfileTabView: View {
    @Query(sort: \CupRecord.drunkAt, order: .reverse) private var records: [CupRecord]
    @EnvironmentObject private var repo: DrinkRepository

    private var drinkCounts: [String: Int] {
        records.reduce(into: [:]) { $0[$1.drinkID, default: 0] += 1 }
    }

    private var totalCups: Int { records.count }
    private var unlockedCount: Int { Set(records.map { $0.drinkID }).count }
    private var currentStreak: Int { AchievementEngine.streak(records: records) }
    private var totalSpent: Int { records.reduce(0) { $0 + $1.computedPrice } }
    private var level: Int { AchievementEngine.level(totalCups: totalCups) }
    private var levelProgress: Double { AchievementEngine.levelProgress(totalCups: totalCups) }
    private var joinDays: Int { AchievementEngine.joinDays(records: records) }

    private var achievementGroups: [AchievementGroupData] {
        AchievementEngine.compute(records: records, drinks: repo.drinks)
    }

    private var favoriteDrink: Drink? {
        guard let topID = drinkCounts.max(by: { $0.value < $1.value })?.key else { return nil }
        return repo.drink(id: topID)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sbCanvas.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        // User Header
                        userHeader

                        // Achievement section
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("成就徽章")
                                    .font(.sbBodyMB)
                                    .foregroundStyle(Color.sbInk)
                                Spacer()
                                Text("查看全部 →")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(Color.sbGreenDeep)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 12)

                            ForEach(achievementGroups) { group in
                                achievementGroupCard(group)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 12)
                            }
                        }

                        // Settings
                        settingsSection
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 32)
                    }
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea(edges: .top)
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: User Header
    private var userHeader: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [Color.sbGreenDeep, Color(hex: "#185F40")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)

            VStack(spacing: 0) {
                // Settings button
                HStack {
                    Spacer()
                    Button {
                        // settings (MVP: placeholder)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.white.opacity(0.9))
                            .frame(width: 36, height: 36)
                            .background(.white.opacity(0.12))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                // Avatar + name
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 64, height: 64)
                            .shadowMd()
                        if let drink = favoriteDrink {
                            DrinkAvatar(drink: drink, size: 56)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.sbGreenDeep.opacity(0.6))
                        }
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Harvey")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundStyle(.white)
                        Text("加入 \(joinDays) 天 · Lv.\(level) 咖啡迷")
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)

                // Level progress
                VStack(spacing: 6) {
                    HStack {
                        Text("Lv.\(level) · \(totalCups) 杯")
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.85))
                        Spacer()
                        Text("Lv.\(level + 1) · 还差 \(AchievementEngine.cupsForNextLevel(totalCups: totalCups)) 杯")
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.15)).frame(height: 5)
                            Capsule().fill(Color.sbAmberSoft)
                                .frame(width: geo.size.width * levelProgress, height: 5)
                                .animation(.easeOut(duration: 0.4), value: levelProgress)
                        }
                    }
                    .frame(height: 5)
                }
                .padding(12)
                .background(.white.opacity(0.10))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 14)

                // Quick stats
                HStack {
                    ForEach([
                        ("\(totalCups)", "总杯数"),
                        ("\(unlockedCount)", "已解锁"),
                        ("\(currentStreak)", "天连击"),
                        ("¥\(totalSpent >= 1000 ? "\(totalSpent / 1000).\(totalSpent % 1000 / 100)k" : "\(totalSpent)")", "累计花费"),
                    ], id: \.0) { value, label in
                        VStack(spacing: 2) {
                            Text(value)
                                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                                .foregroundStyle(.white)
                            Text(label)
                                .font(.system(size: 10))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        if label != "累计花费" {
                            Rectangle()
                                .fill(.white.opacity(0.16))
                                .frame(width: 1, height: 32)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: Achievement group card
    private func achievementGroupCard(_ group: AchievementGroupData) -> some View {
        DCardBorder(padding: 14) {
            VStack(spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(group.title)
                            .font(.sbBodyMB)
                            .foregroundStyle(Color.sbInk)
                        Text(group.subtitle)
                            .font(.sbCaption)
                            .foregroundStyle(Color.sbInk2)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.sbGreenPale).frame(height: 4)
                                Capsule().fill(Color.sbGreenDeep)
                                    .frame(width: geo.size.width * group.groupProgress, height: 4)
                                    .animation(.easeOut(duration: 0.4), value: group.groupProgress)
                            }
                        }
                        .frame(height: 4)
                        .frame(maxWidth: 160)
                    }
                    Spacer()
                    Text("展开 ›")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.sbGreenDeep)
                }

                // 4 badges
                HStack(spacing: 0) {
                    ForEach(group.badges) { badge in
                        VStack(spacing: 4) {
                            BadgeView(kind: badge.badgeKind, isUnlocked: badge.isUnlocked, size: 52)

                            Text(badge.name)
                                .font(.system(size: 10, weight: badge.isUnlocked ? .bold : .medium))
                                .foregroundStyle(badge.isUnlocked ? Color.sbInk : Color.sbInk3)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)

                            Text("\(min(badge.progress, badge.target))/\(badge.target)")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundStyle(badge.isUnlocked ? Color.sbGreenDeep : Color.sbInk3)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    // MARK: Settings
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("支持与设置")
                .font(.sbBodyMB)
                .foregroundStyle(Color.sbInk)

            DCardBorder(padding: 0) {
                VStack(spacing: 0) {
                    ForEach(settingsItems.indices, id: \.self) { i in
                        let item = settingsItems[i]
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.sbGreenPale)
                                    .frame(width: 32, height: 32)
                                Image(systemName: item.icon)
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color.sbGreenDeep)
                            }

                            Text(item.title)
                                .font(.sbBodyM)
                                .foregroundStyle(Color.sbInk)

                            Spacer()

                            if let sub = item.subtitle {
                                Text(sub)
                                    .font(.sbCaption)
                                    .foregroundStyle(Color.sbInk3)
                            }

                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color.sbInk3)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)

                        if i < settingsItems.count - 1 {
                            Divider().padding(.leading, 56)
                        }
                    }
                }
            }

            Text("StarBuddys · v 1.0.0 (build 2026.05)")
                .font(.sbLabel)
                .foregroundStyle(Color.sbInk3)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
        }
    }

    private var settingsItems: [(icon: String, title: String, subtitle: String?)] {[
        ("square.and.arrow.up", "分享给朋友", nil),
        ("globe",               "语言",        "简体中文"),
        ("message",             "意见反馈",    nil),
        ("star",                "给我们评价",  "★★★★☆"),
        ("info.circle",         "关于 StarBuddys", "v 1.0.0"),
    ]}
}

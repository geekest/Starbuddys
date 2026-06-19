import SwiftUI
import SwiftData
import StoreKit

struct ProfileTabView: View {
    @Query(sort: \CupRecord.drunkAt, order: .reverse) private var records: [CupRecord]
    @EnvironmentObject private var repo: DrinkRepository
    @Environment(\.requestReview) private var requestReview

    @State private var selectedBadge: Achievement? = nil
    @State private var showingAbout = false

    private var totalCups: Int { records.count }
    private var unlockedCount: Int { Set(records.map { $0.drinkID }).count }
    private var currentStreak: Int { AchievementEngine.streak(records: records) }
    private var totalSpent: Int { records.reduce(0) { $0 + $1.computedPrice } }
    private var level: Int { AchievementEngine.level(totalCups: totalCups) }
    private var levelProgress: Double { AchievementEngine.levelProgress(totalCups: totalCups) }

    private var achievementGroups: [AchievementGroupData] {
        AchievementEngine.compute(records: records, drinks: repo.drinks)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sbCanvas.ignoresSafeArea()
                VStack(spacing: 0) {
                    Color.sbGreenDeep
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 500)
                    Spacer()
                }
                ScrollView {
                    VStack(spacing: 0) {
                        userHeader

                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("成就徽章")
                                    .font(.sbBodyMB)
                                    .foregroundStyle(Color.sbInk)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 12)

                            allBadgesCard
                                .padding(.horizontal, 20)
                                .padding(.bottom, 12)
                        }

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
            .sheet(item: $selectedBadge) { badge in
                AchievementDetailSheet(achievement: badge)
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
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
                // 等级进度条
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
                .padding(.top, 60)

                // 四项统计
                HStack {
                    ForEach([
                        ("\(totalCups)", "总杯数"),
                        ("\(unlockedCount)", "已解锁"),
                        ("\(currentStreak)", "天连击"),
                        ("¥\(totalSpent >= 1000 ? "\(totalSpent / 1000).\(totalSpent % 1000 / 100)k" : "\(totalSpent)")", "累计花费"),
                    ], id: \.1) { value, label in
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

    // MARK: All badges consolidated card
    private var allBadgesCard: some View {
        let allBadges = achievementGroups.flatMap { $0.badges }
        let unlocked = allBadges.filter { $0.isUnlocked }.count
        let total = allBadges.count
        let progress = Double(unlocked) / Double(max(1, total))

        return DCardBorder(padding: 14) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("已解锁 \(unlocked) / \(total) 项")
                            .font(.sbCaption)
                            .foregroundStyle(Color.sbInk2)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.sbGreenPale).frame(height: 4)
                                Capsule().fill(Color.sbGreenDeep)
                                    .frame(width: geo.size.width * progress, height: 4)
                                    .animation(.easeOut(duration: 0.4), value: progress)
                            }
                        }
                        .frame(height: 4)
                    }
                    Spacer()
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    ForEach(allBadges) { badge in
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
                        .onTapGesture {
                            selectedBadge = badge
                        }
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
                    // 分享给朋友
                    ShareLink(item: "我在用 StarBuddys 记录每一杯星巴克和 Manner 饮品，推荐给你！") {
                        settingsRowView(icon: "square.and.arrow.up", title: "分享给朋友", subtitle: nil)
                    }
                    .buttonStyle(.plain)

                    Divider().padding(.leading, 56)

                    // 意见反馈
                    Button {
                        var components = URLComponents()
                        components.scheme = "mailto"
                        components.path = "xjwwhw@gmail.com"
                        components.queryItems = [URLQueryItem(name: "subject", value: "StarBuddys 意见反馈")]
                        if let url = components.url {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        settingsRowView(icon: "message", title: "意见反馈", subtitle: nil)
                    }
                    .buttonStyle(.plain)

                    Divider().padding(.leading, 56)

                    // 给我们评价
                    Button {
                        requestReview()
                    } label: {
                        settingsRowView(icon: "star", title: "给我们评价", subtitle: "★★★★☆")
                    }
                    .buttonStyle(.plain)

                    Divider().padding(.leading, 56)

                    // 关于 StarBuddys
                    Button {
                        showingAbout = true
                    } label: {
                        settingsRowView(icon: "info.circle", title: "关于 StarBuddys", subtitle: "v 1.0.0")
                    }
                    .buttonStyle(.plain)
                }
            }

            Text("StarBuddys · v 1.0.0 (build 2026.05)")
                .font(.sbLabel)
                .foregroundStyle(Color.sbInk3)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
        }
    }

    private func settingsRowView(icon: String, title: String, subtitle: String?) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.sbGreenPale)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.sbGreenDeep)
            }

            Text(title)
                .font(.sbBodyM)
                .foregroundStyle(Color.sbInk)

            Spacer()

            if let sub = subtitle {
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
    }
}

#Preview("我的 Tab") {
    ProfileTabView()
        .environmentObject(DrinkRepository.shared)
        .modelContainer(for: CupRecord.self, inMemory: true)
}

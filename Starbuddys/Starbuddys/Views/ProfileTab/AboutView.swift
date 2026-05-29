import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.sbLine2)
                    .frame(width: 36, height: 4)
                    .padding(.top, 12)
                    .padding(.bottom, 28)

                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.sbGreenDeep, Color(hex: "#185F40")],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 72)
                    Text("☕")
                        .font(.system(size: 38))
                }

                Text("StarBuddys")
                    .font(.sbTitleL)
                    .foregroundStyle(Color.sbInk)
                    .padding(.top, 14)

                Text("v 1.0.0")
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk3)
                    .padding(.top, 4)

                Text("StarBuddys 是你的私人饮品记录本，帮你记录每一杯星巴克和 Manner 的美好时刻。")
                    .font(.sbBodyM)
                    .foregroundStyle(Color.sbInk2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 16)

                VStack(alignment: .leading, spacing: 16) {
                    featureRow("☕", "点单记录", "记录每杯饮品的杯型、温度、奶型等定制参数")
                    featureRow("📚", "饮品百科", "探索星巴克 67 款 + Manner 43 款全部饮品")
                    featureRow("🏆", "成就系统", "解锁饮品收集、类型大师等 16 项成就徽章")
                    featureRow("📊", "历史统计", "追踪消费记录、天连击与等级成长")
                    featureRow("🎯", "智能推荐", "基于你的喝法，推荐你可能喜欢的新选择")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.sbCanvas))
                .padding(.horizontal, 20)
                .padding(.top, 24)

                Spacer(minLength: 32)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }

    private func featureRow(_ emoji: String, _ title: String, _ desc: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(emoji)
                .font(.system(size: 22))
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                Text(desc)
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk2)
            }
        }
    }
}

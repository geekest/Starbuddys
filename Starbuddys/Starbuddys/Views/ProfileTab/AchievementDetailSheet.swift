import SwiftUI

struct AchievementDetailSheet: View {
    let achievement: Achievement
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.sbLine2)
                .frame(width: 36, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 28)

            BadgeView(kind: achievement.badgeKind, isUnlocked: achievement.isUnlocked, size: 96)

            Text(achievement.group.rawValue)
                .font(.sbCaption)
                .foregroundStyle(Color.sbGreenDeep)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.sbGreenPale))
                .padding(.top, 16)

            Text(achievement.name)
                .font(.sbTitleM)
                .foregroundStyle(Color.sbInk)
                .padding(.top, 10)

            Text(achievement.desc)
                .font(.sbBodyM)
                .foregroundStyle(Color.sbInk2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 8)

            VStack(spacing: 8) {
                HStack {
                    Text("进度")
                        .font(.sbBodyM)
                        .foregroundStyle(Color.sbInk2)
                    Spacer()
                    Text("\(min(achievement.progress, achievement.target)) / \(achievement.target)")
                        .font(.sbBodyMB)
                        .foregroundStyle(achievement.isUnlocked ? Color.sbGreenDeep : Color.sbInk)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.sbGreenPale)
                            .frame(height: 8)
                        Capsule()
                            .fill(achievement.isUnlocked ? Color.sbGreenDeep : Color.sbAmber)
                            .frame(width: geo.size.width * achievement.progressFraction, height: 8)
                            .animation(.easeOut(duration: 0.4), value: achievement.progressFraction)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.sbCanvas))
            .padding(.horizontal, 24)
            .padding(.top, 24)

            HStack(spacing: 6) {
                Image(systemName: achievement.isUnlocked ? "checkmark.seal.fill" : "lock.fill")
                    .foregroundStyle(achievement.isUnlocked ? Color.sbGreenDeep : Color.sbInk3)
                Text(achievement.isUnlocked ? "已解锁" : "尚未解锁")
                    .font(.sbBodyM)
                    .foregroundStyle(achievement.isUnlocked ? Color.sbGreenDeep : Color.sbInk3)
            }
            .padding(.top, 20)

            Spacer()
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
}

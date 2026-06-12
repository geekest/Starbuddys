import SwiftUI

struct BadgeView: View {
    let kind: String
    let isUnlocked: Bool
    var size: CGFloat = 56

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    isUnlocked
                        ? LinearGradient(
                            colors: [badgeColor.opacity(0.22), badgeColor.opacity(0.08)],
                            startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(
                            colors: [Color.sbLine.opacity(0.22), Color.sbLine.opacity(0.10)],
                            startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: size, height: size)

            if isUnlocked {
                Circle()
                    .strokeBorder(badgeColor.opacity(0.38), lineWidth: 1.5)
                    .frame(width: size, height: size)
            }

            Text(badgeEmoji)
                .font(.system(size: size * 0.48))
                .grayscale(isUnlocked ? 0 : 1)
                .opacity(isUnlocked ? 1 : 0.28)

            if !isUnlocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: size * 0.17, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(3)
                    .background(Circle().fill(Color.sbInk3.opacity(0.72)))
                    .offset(x: size * 0.24, y: size * 0.24)
            }
        }
    }

    private var badgeEmoji: String {
        switch kind {
        case "starter":       return "⭐"
        case "half":          return "🌟"
        case "full":          return "👑"
        case "classicMaster": return "☕"
        case "frapMaster":    return "❄️"
        case "teaMaster":     return "🍵"
        case "fan10":         return "💖"
        case "fan50":         return "🔥"
        case "fan100":        return "♾️"
        case "cup100":        return "🚩"
        case "cup500":        return "🏆"
        default:              return "🎖️"
        }
    }

    private var badgeColor: Color {
        switch kind {
        case "starter":       return Color.sbGreenDeep
        case "half":          return Color.sbAmber
        case "full":          return Color.sbAmber
        case "classicMaster": return Color.sbGreenDeep
        case "frapMaster":    return Color(hex: "#5B8FD4")
        case "teaMaster":     return Color.sbMatcha
        case "fan10":         return Color.sbRose
        case "fan50":         return Color(hex: "#E05A1A")
        case "fan100":        return Color.sbBerry
        case "cup100":        return Color.sbGreenDeep
        case "cup500":        return Color.sbAmber
        default:              return Color.sbGreenDeep
        }
    }
}

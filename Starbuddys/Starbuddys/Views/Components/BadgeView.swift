import SwiftUI

struct BadgeView: View {
    let kind: String
    let isUnlocked: Bool
    var size: CGFloat = 56

    var body: some View {
        ZStack {
            Circle()
                .fill(isUnlocked ? badgeColor.opacity(0.15) : Color.sbLine.opacity(0.25))
                .frame(width: size, height: size)

            if isUnlocked {
                badgeImage
                    .font(.system(size: size * 0.42))
                    .foregroundStyle(badgeColor)
            } else {
                badgeImage
                    .font(.system(size: size * 0.38))
                    .foregroundStyle(Color.sbInk3.opacity(0.35))

                Image(systemName: "lock.fill")
                    .font(.system(size: size * 0.2))
                    .foregroundStyle(Color.sbInk3.opacity(0.7))
                    .offset(x: size * 0.22, y: size * 0.22)
            }
        }
    }

    @ViewBuilder
    private var badgeImage: some View {
        switch kind {
        case "starter":       Image(systemName: "star.circle.fill")
        case "half":          Image(systemName: "chart.pie.fill")
        case "full":          Image(systemName: "crown.fill")
        case "classicMaster": Image(systemName: "cup.and.saucer.fill")
        case "frapMaster":    Image(systemName: "snowflake")
        case "teaMaster":     Image(systemName: "leaf.fill")
        case "fan10":         Image(systemName: "heart.fill")
        case "fan50":         Image(systemName: "flame.fill")
        case "fan100":        Image(systemName: "infinity")
        case "cup100":        Image(systemName: "flag.fill")
        case "cup500":        Image(systemName: "trophy.fill")
        default:              Image(systemName: "seal.fill")
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

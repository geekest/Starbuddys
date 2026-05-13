import SwiftUI

struct DrinkAvatar: View {
    let drink: Drink
    var size: CGFloat = 64
    var isLocked: Bool = false
    var count: Int = 0
    var ringColor: Color = .clear

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Circle()
                .fill(Color.sbGreenTint)
                .frame(width: size, height: size)
                .overlay { imageOrPlaceholder }
                .overlay {
                    if isLocked {
                        Circle().fill(.black.opacity(0.45))
                        Image(systemName: "lock.fill")
                            .font(.system(size: size * 0.28, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .overlay {
                    if ringColor != .clear {
                        Circle().strokeBorder(ringColor, lineWidth: 2.5)
                    }
                }
                .grayscale(isLocked ? 1 : 0)

            if count > 0 && !isLocked {
                Text("×\(count)")
                    .font(.system(size: max(8, size * 0.16), weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(count >= 20 ? Color.sbAmber : Color.sbGreenDeep)
                    .clipShape(Capsule())
                    .offset(x: size * 0.12, y: -(size * 0.04))
            }
        }
    }

    @ViewBuilder
    private var imageOrPlaceholder: some View {
        if UIImage(named: drink.imageAssetName) != nil {
            Image(drink.imageAssetName)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .padding(size * 0.08)
        } else {
            Image(systemName: drink.category.systemIcon)
                .font(.system(size: size * 0.38))
                .foregroundStyle(Color.sbGreenDeep.opacity(0.55))
        }
    }
}

// Minimal avatar for records (accepts drinkID + repo lookup)
struct RecordAvatar: View {
    let drinkID: String
    var size: CGFloat = 48
    @EnvironmentObject private var repo: DrinkRepository

    var body: some View {
        if let drink = repo.drink(id: drinkID) {
            DrinkAvatar(drink: drink, size: size)
        } else {
            Circle()
                .fill(Color.sbGreenTint)
                .frame(width: size, height: size)
                .overlay {
                    Image(systemName: "cup.and.saucer.fill")
                        .foregroundStyle(Color.sbGreenDeep.opacity(0.4))
                }
        }
    }
}

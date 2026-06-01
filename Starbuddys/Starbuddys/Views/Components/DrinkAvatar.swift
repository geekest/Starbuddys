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
        if let fileName = drink.userPhotoFileName,
           let uiImage = DrinkStore.shared.loadPhoto(fileName: fileName) {
            // 用户上传的自定义照片
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .padding(size * 0.08)
        } else if UIImage(named: drink.imageAssetName) != nil {
            // Asset Catalog 中的 seed 图片
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

private let _previewDrink = Drink(
    id: "preview", brand: .starbucks, nameCN: "馥芮白", nameEN: "Flat White",
    category: .sbClassicCoffee, description: "浓缩咖啡与醇厚牛奶的完美融合",
    sizes: ["grande": 40], photoAvatar: "", tags: [.hot]
)

#Preview("饮品头像") {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            DrinkAvatar(drink: _previewDrink, size: 80)
            DrinkAvatar(drink: _previewDrink, size: 64, isLocked: true)
            DrinkAvatar(drink: _previewDrink, size: 56, count: 5)
            DrinkAvatar(drink: _previewDrink, size: 48, count: 25)
        }
        HStack(spacing: 16) {
            let manner = Drink(id: "mn", brand: .manner, nameCN: "燕麦拿铁", nameEN: "Oat Latte",
                               category: .mnOat, description: "", sizes: [:], photoAvatar: "", tags: [])
            let luckin  = Drink(id: "lk", brand: .luckin,  nameCN: "生椰拿铁", nameEN: "Coconut Latte",
                                category: .lkLightMilk, description: "", sizes: [:], photoAvatar: "", tags: [])
            DrinkAvatar(drink: manner, size: 64)
            DrinkAvatar(drink: luckin,  size: 64)
        }
    }
    .padding(24)
    .background(Color.sbCanvas)
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

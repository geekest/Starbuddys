import Foundation

struct Drink: Identifiable, Codable, Hashable {
    let id: String
    let nameCN: String
    let nameEN: String
    let category: DrinkCategory
    let subCategory: String?
    let description: String
    let sizes: [String: Int]
    let imageName: String
    let tags: [DrinkTag]

    var sizePrices: [CupSize: Int] {
        var result: [CupSize: Int] = [:]
        for (key, value) in sizes {
            if let size = CupSize(rawValue: key) {
                result[size] = value
            }
        }
        return result
    }

    var defaultSize: CupSize {
        let prices = sizePrices
        if prices[.grande] != nil { return .grande }
        if prices[.tall] != nil { return .tall }
        if prices[.venti] != nil { return .venti }
        return .grande
    }

    var isCoffee: Bool {
        category == .craftedCoffee
    }

    var defaultTemperature: Temperature {
        if tags.contains(.cold) { return .iceNormal }
        if category == .frappuccino { return .iceNormal }
        if tags.contains(.hot) { return .hot }
        return .hot
    }

    var defaultMilk: MilkType {
        if tags.contains(.oatmilk) { return .oat }
        if tags.contains(.almondmilk) { return .whole }
        return .whole
    }

    var imageAssetName: String {
        var name = imageName
        for ext in [".PNG", ".png", ".JPG", ".jpg"] {
            if name.hasSuffix(ext) {
                name = String(name.dropLast(ext.count))
                break
            }
        }
        return name
    }
}

struct DrinkSeedData: Codable {
    let version: Int
    let drinks: [Drink]
}

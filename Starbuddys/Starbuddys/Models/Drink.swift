import Foundation

struct Drink: Identifiable, Codable, Hashable {
    let id: String
    let brand: BrandType
    let nameCN: String
    let nameEN: String
    let category: DrinkCategory
    let subCategory: String?
    let description: String
    let sizes: [String: Int]
    let imageName: String
    let tags: [DrinkTag]

    init(id: String, brand: BrandType = .starbucks, nameCN: String, nameEN: String,
         category: DrinkCategory, subCategory: String?, description: String,
         sizes: [String: Int], imageName: String, tags: [DrinkTag]) {
        self.id = id
        self.brand = brand
        self.nameCN = nameCN
        self.nameEN = nameEN
        self.category = category
        self.subCategory = subCategory
        self.description = description
        self.sizes = sizes
        self.imageName = imageName
        self.tags = tags
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        nameCN = try c.decode(String.self, forKey: .nameCN)
        nameEN = try c.decode(String.self, forKey: .nameEN)
        category = try c.decode(DrinkCategory.self, forKey: .category)
        subCategory = try c.decodeIfPresent(String.self, forKey: .subCategory)
        description = try c.decode(String.self, forKey: .description)
        sizes = try c.decode([String: Int].self, forKey: .sizes)
        imageName = try c.decode(String.self, forKey: .imageName)
        // 未知 tag 直接忽略，避免一条脏数据让整份 seed 解析失败
        tags = (try c.decodeIfPresent([String].self, forKey: .tags) ?? []).compactMap(DrinkTag.init(rawValue:))
        // 兼容旧数据：未指定 brand 时按分类推断
        if let raw = try c.decodeIfPresent(String.self, forKey: .brand),
           let b = BrandType(rawValue: raw) {
            brand = b
        } else {
            brand = category.brand
        }
    }

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

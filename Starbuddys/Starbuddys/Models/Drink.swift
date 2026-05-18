import Foundation

struct Drink: Identifiable, Codable, Hashable {
    let id: String
    let brand: BrandType
    let nameCN: String
    let nameEN: String
    let category: DrinkCategory
    let description: String
    let sizes: [String: Int]
    /// 图片文件名（含扩展名），支持 photoAvatar / imageName 两种 JSON 字段名
    let photoAvatar: String
    let tags: [DrinkTag]

    init(id: String, brand: BrandType = .starbucks, nameCN: String, nameEN: String,
         category: DrinkCategory, description: String,
         sizes: [String: Int], photoAvatar: String, tags: [DrinkTag]) {
        self.id = id
        self.brand = brand
        self.nameCN = nameCN
        self.nameEN = nameEN
        self.category = category
        self.description = description
        self.sizes = sizes
        self.photoAvatar = photoAvatar
        self.tags = tags
    }

    /// 主 CodingKeys —— 属性与 JSON key 完全对应，供自动合成 encode(to:) 使用
    private enum CodingKeys: String, CodingKey {
        case id, brand, nameCN, nameEN, category, description, sizes, tags, photoAvatar
    }

    /// 旧 manner.seed.json 使用 imageName 字段，单独定义以兼容解码
    private enum LegacyKeys: String, CodingKey {
        case imageName
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id          = try c.decode(String.self, forKey: .id)
        nameCN      = try c.decode(String.self, forKey: .nameCN)
        nameEN      = try c.decodeIfPresent(String.self, forKey: .nameEN) ?? ""
        category    = try c.decode(DrinkCategory.self, forKey: .category)
        description = try c.decode(String.self, forKey: .description)
        sizes       = try c.decode([String: Int].self, forKey: .sizes)
        // 兼容两种字段名：新 JSON 用 photoAvatar，旧 manner.seed 用 imageName
        if let pa = try c.decodeIfPresent(String.self, forKey: .photoAvatar) {
            photoAvatar = pa
        } else {
            let legacy = try decoder.container(keyedBy: LegacyKeys.self)
            photoAvatar = try legacy.decodeIfPresent(String.self, forKey: .imageName) ?? ""
        }
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
        switch category {
        // 星巴克：含浓缩/冷萃的品类展示浓缩定制区
        case .sbHighProtein, .sbRose, .sbClassicCoffee, .sbPlantCoffee,
             .sbYuanyang, .sbColdBrew, .sbGoldRoast, .sbShakenEspresso:
            return true
        case .sbPourOver, .sbFrappTea, .sbFrappCoffee, .sbFrappFruit,
             .sbTeaLatte, .sbShakenTea, .sbOther, .sbRefreshers:
            return false
        // Manner
        case .mnSeasonal, .mnTreasure, .mnFruitAmericano, .mnVenti,
             .mnClassicEspresso, .mnSOE, .mnMilkCoffee, .mnOat:
            return true
        case .mnNonCoffee:
            return false
        }
    }

    var defaultTemperature: Temperature {
        if tags.contains(.cold) { return .iceNormal }
        if category.isFrappuccino   { return .iceNormal }
        if tags.contains(.hot)      { return .hot }
        return .hot
    }

    var defaultMilk: MilkType {
        if tags.contains(.oatmilk) { return .oat }
        if tags.contains(.almondmilk) { return .whole }
        return .whole
    }

    /// Asset Catalog 中的资源名（去掉扩展名）
    var imageAssetName: String {
        var name = photoAvatar
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

import Foundation

/// 统一的饮品数据条目，内置饮品（seed）和用户新增饮品均存储为此类型
struct DrinkEntry: Identifiable, Codable {
    var id: String
    var brandRaw: String           // BrandType.rawValue
    var nameCN: String
    var nameEN: String
    var categoryName: String       // DrinkCategory.rawValue 或用户自定义字符串
    var drinkDescription: String
    var sizes: [String: Int]       // 杯型价格表（用户新增饮品为空）
    var photoAvatar: String        // Asset Catalog 图片名（用户新增饮品为空）
    var tagsRaw: [String]          // DrinkTag.rawValue 数组
    var photoFileName: String?     // Documents 目录的用户上传照片文件名
    var photoScale: Double         // 照片展示缩放比例
    var photoAngle: Double         // 照片展示旋转角度（度）
    var isBuiltIn: Bool            // true = 来自 seed 文件（内置饮品）
    var isHidden: Bool             // 逻辑删除标志
    var createdAt: Date

    init(id: String, brandRaw: String, nameCN: String, nameEN: String = "",
         categoryName: String, drinkDescription: String = "",
         sizes: [String: Int] = [:], photoAvatar: String = "", tagsRaw: [String] = [],
         photoFileName: String? = nil, photoScale: Double = 1.0, photoAngle: Double = 0.0,
         isBuiltIn: Bool = false, isHidden: Bool = false, createdAt: Date = Date()) {
        self.id               = id
        self.brandRaw         = brandRaw
        self.nameCN           = nameCN
        self.nameEN           = nameEN
        self.categoryName     = categoryName
        self.drinkDescription = drinkDescription
        self.sizes            = sizes
        self.photoAvatar      = photoAvatar
        self.tagsRaw          = tagsRaw
        self.photoFileName    = photoFileName
        self.photoScale       = photoScale
        self.photoAngle       = photoAngle
        self.isBuiltIn        = isBuiltIn
        self.isHidden         = isHidden
        self.createdAt        = createdAt
    }

    /// 从 seed 文件解码出的 Drink 对象构造内置条目
    init(from drink: Drink) {
        id               = drink.id
        brandRaw         = drink.brand.rawValue
        nameCN           = drink.nameCN
        nameEN           = drink.nameEN
        categoryName     = drink.category.rawValue
        drinkDescription = drink.description
        sizes            = drink.sizes
        photoAvatar      = drink.photoAvatar
        tagsRaw          = drink.tags.map { $0.rawValue }
        photoFileName    = nil
        photoScale       = 1.0
        photoAngle       = 0.0
        isBuiltIn        = true
        isHidden         = false
        createdAt        = .distantPast
    }

    // 向后兼容的解码（旧 UserDrinkEntry JSON 缺少新字段时使用默认值）
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id               = try c.decode(String.self, forKey: .id)
        brandRaw         = try c.decode(String.self, forKey: .brandRaw)
        nameCN           = try c.decode(String.self, forKey: .nameCN)
        nameEN           = try c.decodeIfPresent(String.self, forKey: .nameEN) ?? ""
        categoryName     = try c.decode(String.self, forKey: .categoryName)
        drinkDescription = try c.decodeIfPresent(String.self, forKey: .drinkDescription) ?? ""
        sizes            = try c.decodeIfPresent([String: Int].self, forKey: .sizes) ?? [:]
        photoAvatar      = try c.decodeIfPresent(String.self, forKey: .photoAvatar) ?? ""
        tagsRaw          = try c.decodeIfPresent([String].self, forKey: .tagsRaw) ?? []
        photoFileName    = try c.decodeIfPresent(String.self, forKey: .photoFileName)
        photoScale       = try c.decodeIfPresent(Double.self, forKey: .photoScale) ?? 1.0
        photoAngle       = try c.decodeIfPresent(Double.self, forKey: .photoAngle) ?? 0.0
        isBuiltIn        = try c.decodeIfPresent(Bool.self, forKey: .isBuiltIn) ?? false
        isHidden         = try c.decodeIfPresent(Bool.self, forKey: .isHidden) ?? false
        createdAt        = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? .distantPast
    }
}

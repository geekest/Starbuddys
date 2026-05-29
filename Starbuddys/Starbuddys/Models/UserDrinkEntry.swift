import Foundation

/// 用户手动新增的自定义饮品数据结构，持久化为 JSON 文件
struct UserDrinkEntry: Identifiable, Codable {
    var id: String
    var brandRaw: String         // BrandType.rawValue
    var nameCN: String
    var nameEN: String
    /// 品类名：可以是 DrinkCategory.rawValue，也可以是用户自定义字符串（≤10汉字）
    var categoryName: String
    var drinkDescription: String
    /// 用户上传照片的文件名，存放于 Documents 目录；nil 表示无自定义图片
    var photoFileName: String?
    /// 照片展示缩放比例，默认 1.0
    var photoScale: Double
    /// 照片展示旋转角度（度），默认 0.0
    var photoAngle: Double
    /// 逻辑删除标志，true 时不在饮品库展示，但历史记录仍可查到
    var isHidden: Bool
    var createdAt: Date

    init(brandRaw: String, nameCN: String, nameEN: String = "",
         categoryName: String, drinkDescription: String = "",
         photoFileName: String? = nil) {
        self.id               = "usr_" + UUID().uuidString
        self.brandRaw         = brandRaw
        self.nameCN           = nameCN
        self.nameEN           = nameEN
        self.categoryName     = categoryName
        self.drinkDescription = drinkDescription
        self.photoFileName    = photoFileName
        self.photoScale       = 1.0
        self.photoAngle       = 0.0
        self.isHidden         = false
        self.createdAt        = Date()
    }
}

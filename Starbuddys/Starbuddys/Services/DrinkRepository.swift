import Foundation
import Combine

@MainActor
final class DrinkRepository: ObservableObject {
    static let shared = DrinkRepository()

    /// 对外公开的全量饮品（seed + 用户自建，不含已删除）
    @Published private(set) var drinks: [Drink] = []

    private var seedDrinks: [Drink] = []
    private var userDrinksCache: [Drink] = []

    private init() {
        load()
        reloadUserDrinks()
    }

    // MARK: - 加载 seed JSON

    private func load() {
        var combined: [Drink] = []
        for name in ["drinks.seed", "manner.seed", "luckin.seed"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
                if name == "drinks.seed" {
                    assertionFailure("\(name).json not found in bundle")
                }
                continue
            }
            do {
                let data   = try Data(contentsOf: url)
                let parsed = try JSONDecoder().decode(DrinkSeedData.self, from: data).drinks
                combined.append(contentsOf: parsed)
            } catch {
                assertionFailure("Failed to load \(name).json: \(error)")
            }
        }
        seedDrinks = combined
        refreshDrinks()
    }

    // MARK: - 用户饮品管理

    /// 将 UserDrinkStore 中的条目转换为 Drink 对象并刷新缓存
    func reloadUserDrinks() {
        userDrinksCache = UserDrinkStore.shared.entries.compactMap { entry in
            guard let brand = BrandType(rawValue: entry.brandRaw) else { return nil }
            // 判断 categoryName 是否匹配标准分类；不匹配时使用品牌第一个分类作为内部占位，并记录自定义名称
            let matchedCategory = DrinkCategory(rawValue: entry.categoryName)
            let category        = matchedCategory ?? (DrinkCategory.categories(for: brand).first ?? .sbOther)
            let customCatName: String? = matchedCategory == nil ? entry.categoryName : nil

            return Drink(
                id: entry.id,
                brand: brand,
                nameCN: entry.nameCN,
                nameEN: entry.nameEN,
                category: category,
                description: entry.drinkDescription,
                sizes: [:],
                photoAvatar: "",
                tags: [],
                customCategoryName: customCatName,
                userPhotoFileName: entry.photoFileName,
                isUserCreated: true
            )
        }
        refreshDrinks()
    }

    private func refreshDrinks() {
        drinks = seedDrinks + userDrinksCache
    }

    // MARK: - 查询

    func drink(id: String) -> Drink? {
        drinks.first { $0.id == id }
    }

    /// 历史记录专用查询，包含已逻辑删除的用户饮品
    func drinkForHistory(id: String) -> Drink? {
        if let found = drinks.first(where: { $0.id == id }) { return found }
        // 在隐藏的用户饮品中查找
        guard let entry = UserDrinkStore.shared.allEntries.first(where: { $0.id == id }),
              let brand = BrandType(rawValue: entry.brandRaw) else { return nil }
        let matchedCategory = DrinkCategory(rawValue: entry.categoryName)
        let category        = matchedCategory ?? (DrinkCategory.categories(for: brand).first ?? .sbOther)
        let customCatName: String? = matchedCategory == nil ? entry.categoryName : nil
        return Drink(
            id: entry.id,
            brand: brand,
            nameCN: entry.nameCN,
            nameEN: entry.nameEN,
            category: category,
            description: entry.drinkDescription,
            sizes: [:],
            photoAvatar: "",
            tags: [],
            customCategoryName: customCatName,
            userPhotoFileName: entry.photoFileName,
            isUserCreated: true
        )
    }

    func drinks(for category: DrinkCategory) -> [Drink] {
        drinks.filter { $0.category == category }
    }

    func drinks(brand: BrandType) -> [Drink] {
        drinks.filter { $0.brand == brand }
    }

    func drinks(brand: BrandType, category: DrinkCategory) -> [Drink] {
        drinks.filter { $0.brand == brand && $0.category == category }
    }

    func search(_ query: String) -> [Drink] {
        guard !query.isEmpty else { return drinks }
        let q = query.lowercased()
        return drinks.filter {
            $0.nameCN.lowercased().contains(q) ||
            $0.nameEN.lowercased().contains(q) ||
            ($0.customCategoryName ?? $0.category.rawValue).lowercased().contains(q)
        }
    }
}

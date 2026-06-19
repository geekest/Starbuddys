import Foundation
import Combine

@MainActor
final class DrinkRepository: ObservableObject {
    static let shared = DrinkRepository()

    /// 对外公开的全量饮品（不含已删除），由 DrinkStore.$entries 驱动
    @Published private(set) var drinks: [Drink] = []

    private var cancellable: AnyCancellable?

    private init() {
        cancellable = DrinkStore.shared.$entries
            .sink { [weak self] entries in
                self?.drinks = entries.map { Drink(from: $0) }
            }
    }

    // MARK: - 查询

    func drink(id: String) -> Drink? {
        drinks.first { $0.id == id }
    }

    /// 历史记录专用：包含已逻辑删除的饮品
    func drinkForHistory(id: String) -> Drink? {
        if let found = drinks.first(where: { $0.id == id }) { return found }
        return DrinkStore.shared.entry(id: id).map { Drink(from: $0) }
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

import Foundation

@MainActor
final class DrinkRepository: ObservableObject {
    static let shared = DrinkRepository()

    @Published private(set) var drinks: [Drink] = []

    private init() { load() }

    private func load() {
        guard let url = Bundle.main.url(forResource: "drinks.seed", withExtension: "json") else {
            assertionFailure("drinks.seed.json not found in bundle")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            drinks = try JSONDecoder().decode(DrinkSeedData.self, from: data).drinks
        } catch {
            assertionFailure("Failed to load drinks.seed.json: \(error)")
        }
    }

    func drink(id: String) -> Drink? {
        drinks.first { $0.id == id }
    }

    func drinks(for category: DrinkCategory) -> [Drink] {
        drinks.filter { $0.category == category }
    }

    func search(_ query: String) -> [Drink] {
        guard !query.isEmpty else { return drinks }
        let q = query.lowercased()
        return drinks.filter {
            $0.nameCN.lowercased().contains(q) ||
            $0.nameEN.lowercased().contains(q) ||
            ($0.subCategory?.lowercased().contains(q) ?? false)
        }
    }
}

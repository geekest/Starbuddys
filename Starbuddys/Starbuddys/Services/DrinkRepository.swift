import Foundation
import Combine

@MainActor
final class DrinkRepository: ObservableObject {
    static let shared = DrinkRepository()

    @Published private(set) var drinks: [Drink] = []

    private init() { load() }

    private func load() {
        var combined: [Drink] = []
        for name in ["drinks.seed", "manner.seed"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
                if name == "drinks.seed" {
                    assertionFailure("\(name).json not found in bundle")
                }
                continue
            }
            do {
                let data = try Data(contentsOf: url)
                let parsed = try JSONDecoder().decode(DrinkSeedData.self, from: data).drinks
                combined.append(contentsOf: parsed)
            } catch {
                assertionFailure("Failed to load \(name).json: \(error)")
            }
        }
        drinks = combined
    }

    func drink(id: String) -> Drink? {
        drinks.first { $0.id == id }
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
            $0.category.rawValue.lowercased().contains(q)
        }
    }
}

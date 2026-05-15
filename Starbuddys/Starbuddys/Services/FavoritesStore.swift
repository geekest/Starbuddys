import Foundation
import Combine

@MainActor
final class FavoritesStore: ObservableObject {
    static let shared = FavoritesStore()

    @Published private(set) var favoriteIDs: Set<String>

    private let key = "favoriteDrinkIDs"

    private init() {
        let stored = UserDefaults.standard.array(forKey: "favoriteDrinkIDs") as? [String] ?? []
        favoriteIDs = Set(stored)
    }

    func isFavorite(_ drinkID: String) -> Bool {
        favoriteIDs.contains(drinkID)
    }

    func toggle(_ drinkID: String) {
        if favoriteIDs.contains(drinkID) {
            favoriteIDs.remove(drinkID)
        } else {
            favoriteIDs.insert(drinkID)
        }
        UserDefaults.standard.set(Array(favoriteIDs), forKey: key)
    }
}

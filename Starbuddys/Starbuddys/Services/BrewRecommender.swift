import Foundation

final class BrewRecommender {

    static func recommend(from drinks: [Drink], records: [CupRecord]) -> Drink? {
        guard !drinks.isEmpty else { return nil }

        let hour  = Calendar.current.component(.hour, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let drinkCounts: [String: Int] = records.reduce(into: [:]) { $0[$1.drinkID, default: 0] += 1 }
        let recentIDs = Set(records.prefix(5).map { $0.drinkID })
        let isColdSeason = month >= 11 || month <= 3

        var candidates = drinks.filter { !$0.sizePrices.isEmpty }
        if candidates.isEmpty { candidates = drinks }

        func weight(for drink: Drink) -> Double {
            var w = 1.0
            let count = drinkCounts[drink.id] ?? 0

            if count == 0 { w *= 2.0 }

            switch hour {
            case 5..<11:
                if drink.tags.contains(.latte) || drink.tags.contains(.americano) { w *= 1.5 }
            case 14..<18:
                if drink.category == .frappuccino || drink.tags.contains(.cold) { w *= 1.5 }
            case 18...:
                if drink.category == .tea || drink.tags.contains(.noAddedSugar) { w *= 1.5 }
            default:
                break
            }

            if isColdSeason && drink.tags.contains(.hot)  { w *= 1.3 }
            if !isColdSeason && drink.tags.contains(.cold) { w *= 1.3 }
            if recentIDs.contains(drink.id) { w *= 0.3 }

            return max(0.1, w)
        }

        let weights = candidates.map { weight(for: $0) }
        let total = weights.reduce(0, +)
        var r = Double.random(in: 0..<max(total, 0.01))

        for (drink, w) in zip(candidates, weights) {
            r -= w
            if r <= 0 { return drink }
        }
        return candidates.randomElement()
    }

    static func defaultConfig(for drink: Drink) -> (CupSize, Temperature, SugarLevel) {
        (drink.defaultSize, drink.defaultTemperature, .standard)
    }
}

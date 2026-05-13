import Foundation
import SwiftData

struct FlavorAddon: Codable, Hashable {
    var name: String
    var count: Int
    var extraPrice: Int
}

@Model
final class CupRecord {
    var id: UUID
    var drinkID: String
    var drunkAt: Date
    var cupSizeRaw: String
    var temperatureRaw: String
    var sugarLevelRaw: String
    var shotCount: Int
    var extraShots: Int
    var milkTypeRaw: String
    var flavorsData: Data
    var rating: Int
    var note: String?
    var photoData: Data?
    var computedPrice: Int
    var isFirstTime: Bool

    init(
        id: UUID = UUID(),
        drinkID: String,
        drunkAt: Date = Date(),
        cupSize: CupSize,
        temperature: Temperature,
        sugarLevel: SugarLevel,
        shotCount: Int,
        extraShots: Int = 0,
        milkType: MilkType,
        flavors: [FlavorAddon] = [],
        rating: Int = 4,
        note: String? = nil,
        photoData: Data? = nil,
        computedPrice: Int,
        isFirstTime: Bool = false
    ) {
        self.id = id
        self.drinkID = drinkID
        self.drunkAt = drunkAt
        self.cupSizeRaw = cupSize.rawValue
        self.temperatureRaw = temperature.rawValue
        self.sugarLevelRaw = sugarLevel.rawValue
        self.shotCount = shotCount
        self.extraShots = extraShots
        self.milkTypeRaw = milkType.rawValue
        self.flavorsData = (try? JSONEncoder().encode(flavors)) ?? Data()
        self.rating = rating
        self.note = note
        self.photoData = photoData
        self.computedPrice = computedPrice
        self.isFirstTime = isFirstTime
    }

    var cupSize: CupSize { CupSize(rawValue: cupSizeRaw) ?? .grande }
    var temperature: Temperature { Temperature(rawValue: temperatureRaw) ?? .hot }
    var sugarLevel: SugarLevel { SugarLevel(rawValue: sugarLevelRaw) ?? .standard }
    var milkType: MilkType { MilkType(rawValue: milkTypeRaw) ?? .whole }
    var flavors: [FlavorAddon] { (try? JSONDecoder().decode([FlavorAddon].self, from: flavorsData)) ?? [] }

    var shortSpec: String {
        "\(cupSize.displayName) / \(temperature.rawValue) / \(sugarLevel.rawValue)"
    }
}

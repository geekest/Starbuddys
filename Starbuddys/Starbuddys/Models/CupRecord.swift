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
    var milkTypeRaw: String
    var espressoTypeRaw: String?
    var espressoStrengthRaw: String?
    var espressoShotsRaw: String?
    var foamLevelRaw: String?
    var sweetOptionRaw: String?
    var sweetPositionRaw: String?
    var whippedCreamLevelRaw: String?
    var flavorSyrupsData: Data
    var sugarLevelRaw: String?
    var shotCount: Int
    var extraShots: Int
    var flavorsData: Data
    var customPrice: Int?
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
        milkType: MilkType,
        espressoType: EspressoType? = nil,
        espressoStrength: EspressoStrength? = nil,
        espressoShots: Int? = nil,
        foamLevel: FoamLevel? = nil,
        sweetOption: SweetOption? = nil,
        sweetPosition: SweetPosition? = nil,
        whippedCreamLevel: WhippedCreamLevel? = nil,
        flavorSyrups: [FlavorSyrup] = [],
        sugarLevel: SugarLevel? = nil,
        shotCount: Int = 0,
        extraShots: Int = 0,
        flavors: [FlavorAddon] = [],
        customPrice: Int? = nil,
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
        self.milkTypeRaw = milkType.rawValue
        self.espressoTypeRaw = espressoType?.rawValue
        self.espressoStrengthRaw = espressoStrength?.rawValue
        self.espressoShotsRaw = espressoShots.map(String.init)
        self.foamLevelRaw = foamLevel?.rawValue
        self.sweetOptionRaw = sweetOption?.rawValue
        self.sweetPositionRaw = sweetPosition?.rawValue
        self.whippedCreamLevelRaw = whippedCreamLevel?.rawValue
        self.flavorSyrupsData = (try? JSONEncoder().encode(flavorSyrups)) ?? Data()
        self.sugarLevelRaw = sugarLevel?.rawValue
        self.shotCount = shotCount
        self.extraShots = extraShots
        self.flavorsData = (try? JSONEncoder().encode(flavors)) ?? Data()
        self.customPrice = customPrice
        self.rating = rating
        self.note = note
        self.photoData = photoData
        self.computedPrice = computedPrice
        self.isFirstTime = isFirstTime
    }

    var cupSize: CupSize { CupSize(rawValue: cupSizeRaw) ?? .grande }
    var temperature: Temperature { Temperature(rawValue: temperatureRaw) ?? .hot }
    var milkType: MilkType { MilkType(rawValue: milkTypeRaw) ?? .whole }
    var espressoType: EspressoType? { espressoTypeRaw.flatMap(EspressoType.init) }
    var espressoStrength: EspressoStrength? { espressoStrengthRaw.flatMap(EspressoStrength.init) }
    var espressoShots: Int? { espressoShotsRaw.flatMap(Int.init) }
    var foamLevel: FoamLevel? { foamLevelRaw.flatMap(FoamLevel.init) }
    var sweetOption: SweetOption? { sweetOptionRaw.flatMap(SweetOption.init) }
    var sweetPosition: SweetPosition? { sweetPositionRaw.flatMap(SweetPosition.init) }
    var whippedCreamLevel: WhippedCreamLevel? { whippedCreamLevelRaw.flatMap(WhippedCreamLevel.init) }
    var flavorSyrups: [FlavorSyrup] { (try? JSONDecoder().decode([FlavorSyrup].self, from: flavorSyrupsData)) ?? [] }
    var sugarLevel: SugarLevel? { sugarLevelRaw.flatMap(SugarLevel.init) }
    var flavors: [FlavorAddon] { (try? JSONDecoder().decode([FlavorAddon].self, from: flavorsData)) ?? [] }

    var shortSpec: String {
        "\(cupSize.displayName) / \(temperature.rawValue) / \(milkType.rawValue)"
    }
}

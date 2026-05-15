import Foundation

enum BrandType: String, Codable, CaseIterable, Hashable {
    case starbucks = "starbucks"
    case manner    = "manner"

    var displayName: String {
        switch self {
        case .starbucks: return "星巴克"
        case .manner:    return "Manner"
        }
    }

    var shortName: String {
        switch self {
        case .starbucks: return "星巴克"
        case .manner:    return "Manner"
        }
    }
}

enum DrinkCategory: String, Codable, CaseIterable, Hashable {
    // 星巴克
    case craftedCoffee = "手工调制咖啡"
    case frappuccino   = "星冰乐"
    case tea           = "茶饮"
    case refreshers    = "星巴克生咖 Refreshers"
    case other         = "其他饮品"

    // Manner
    case mnSeasonal       = "季节新品"
    case mnTreasure       = "珍藏系列"
    case mnFruitAmericano = "果味美式"
    case mnVenti          = "超大杯系列"
    case mnClassicEspresso = "经典意式"
    case mnSOE            = "单品豆SOE"
    case mnMilkCoffee     = "热卖奶咖"
    case mnOat            = "燕麦系列"
    case mnNonCoffee      = "无咖啡系列"

    var displayName: String { rawValue }

    var label: String {
        self == .refreshers ? "生咖" : rawValue
    }

    var brand: BrandType {
        switch self {
        case .craftedCoffee, .frappuccino, .tea, .refreshers, .other:
            return .starbucks
        case .mnSeasonal, .mnTreasure, .mnFruitAmericano, .mnVenti,
             .mnClassicEspresso, .mnSOE, .mnMilkCoffee, .mnOat, .mnNonCoffee:
            return .manner
        }
    }

    static func categories(for brand: BrandType) -> [DrinkCategory] {
        allCases.filter { $0.brand == brand }
    }

    var systemIcon: String {
        switch self {
        case .craftedCoffee:     return "cup.and.saucer.fill"
        case .frappuccino:       return "snowflake"
        case .tea:               return "leaf.fill"
        case .refreshers:        return "bolt.fill"
        case .other:             return "mug.fill"
        case .mnSeasonal:        return "sparkles"
        case .mnTreasure:        return "star.fill"
        case .mnFruitAmericano:  return "drop.fill"
        case .mnVenti:           return "cup.and.saucer.fill"
        case .mnClassicEspresso: return "cup.and.saucer.fill"
        case .mnSOE:             return "leaf.circle.fill"
        case .mnMilkCoffee:      return "mug.fill"
        case .mnOat:             return "leaf.fill"
        case .mnNonCoffee:       return "drop.circle.fill"
        }
    }
}

enum CupSize: String, Codable, CaseIterable, Hashable {
    case tall  = "tall"
    case grande = "grande"
    case venti = "venti"

    var displayName: String {
        switch self {
        case .tall:   return "中杯"
        case .grande: return "大杯"
        case .venti:  return "超大杯"
        }
    }

    var ml: String {
        switch self {
        case .tall:   return "355ml"
        case .grande: return "473ml"
        case .venti:  return "591ml"
        }
    }
}

enum Temperature: String, Codable, CaseIterable, Hashable {
    case extraHot  = "特别热"
    case hot       = "热"
    case warm      = "微热"
    case iceNormal = "冰"
    case iceLess   = "少冰"
    case iceNone   = "去冰"
    case iceFull   = "全冰"
}

enum SugarLevel: String, Codable, CaseIterable, Hashable {
    case standard = "标准"
    case less     = "少糖"
    case half     = "半糖"
    case micro    = "微糖"
    case none     = "无糖"
}

enum MilkType: String, Codable, CaseIterable, Hashable {
    case whole    = "全脂牛奶"
    case almond   = "巴旦木奶"
    case oat      = "燕麦奶"
    case lowFat   = "脱脂牛奶"
    case none     = "无奶"
}

enum DrinkTag: String, Codable, Hashable {
    case cold
    case hot
    case matcha
    case oatmilk
    case almondmilk
    case highProtein  = "high_protein"
    case noAddedSugar = "no_added_sugar"
    case floral
    case chocolate
    case caramel
    case vanilla
    case tea
    case americano
    case latte
}

enum AchievementGroup: String, CaseIterable, Codable, Hashable {
    case collection = "饮品收集"
    case typeMaster = "类型大师"
    case singleFan  = "单品狂热"
    case milestone  = "累计里程碑"
}

enum EspressoType: String, Codable, CaseIterable, Hashable {
    case classic = "经典浓缩(深烘)"
    case golden  = "金烘浓缩(浅烘)"
    case decaf   = "低因浓缩(深烘)"

    var displayName: String { rawValue }
}

enum EspressoStrength: String, Codable, CaseIterable, Hashable {
    case original = "原萃浓缩"
    case refined  = "精萃浓缩"
    case full     = "满萃浓缩"

    var displayName: String { rawValue }

    var subtitle: String {
        switch self {
        case .original: return "浓郁醇香，焦糖般甜感"
        case .refined:  return "精炼萃取，倍感甜郁"
        case .full:     return "深度萃取，焦香饱满"
        }
    }
}

enum FoamLevel: String, Codable, CaseIterable, Hashable {
    case topFoam     = "杯盖奶泡"
    case dryFoam     = "奶泡紧干"
    case lessFoam    = "奶泡紧(亚)"

    var displayName: String { rawValue }
}

enum SweetOption: String, Codable, CaseIterable, Hashable {
    case standard    = "经典糖"
    case zero        = "0甜度糖"
    case none        = "不另外添加"

    var displayName: String { rawValue }
}

enum SweetPosition: String, Codable, CaseIterable, Hashable {
    case standard    = "标准"
    case more        = "多"
    case extra       = "更多"

    var displayName: String { rawValue }
}

enum WhippedCreamLevel: String, Codable, CaseIterable, Hashable {
    case less        = "加少量搅打标的油"
    case normal      = "加搅搅打标的油"
    case none        = "少搅打标的油"

    var displayName: String { rawValue }
}

enum FlavorSyrup: String, Codable, CaseIterable, Hashable {
    case vanilla         = "香草风味"
    case hazelnut        = "榛果风味"
    case saltCaramel     = "海盐焦糖风味"
    case tahitianVanilla = "大溪地香草风味"
    case berry           = "莓莓风味"
    case pandan          = "糯香斑斓风味"

    var displayName: String { rawValue }
}

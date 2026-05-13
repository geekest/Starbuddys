import Foundation

enum DrinkCategory: String, Codable, CaseIterable, Hashable {
    case craftedCoffee = "手工调制咖啡"
    case frappuccino   = "星冰乐"
    case tea           = "茶饮"
    case refreshers    = "星巴克生咖 Refreshers"
    case other         = "其他饮品"

    var displayName: String { rawValue }

    var systemIcon: String {
        switch self {
        case .craftedCoffee: return "cup.and.saucer.fill"
        case .frappuccino:   return "snowflake"
        case .tea:           return "leaf.fill"
        case .refreshers:    return "bolt.fill"
        case .other:         return "mug.fill"
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
    case hot       = "热饮"
    case iceNormal = "正常冰"
    case iceLess   = "少冰"
    case iceNone   = "去冰"
}

enum SugarLevel: String, Codable, CaseIterable, Hashable {
    case standard = "标准"
    case less     = "少糖"
    case half     = "半糖"
    case micro    = "微糖"
    case none     = "无糖"
}

enum MilkType: String, Codable, CaseIterable, Hashable {
    case whole  = "标准奶"
    case lowFat = "低脂奶"
    case oat    = "燕麦奶"
    case soy    = "豆奶"
    case none   = "不加奶"
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

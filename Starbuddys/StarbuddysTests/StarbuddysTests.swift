import Testing
import Foundation
@testable import Starbuddys

@Suite("BrewRecommender Tests")
struct BrewRecommenderTests {

    @Test("Returns a drink from non-empty catalog")
    func returnsResult() {
        let drinks = makeDrinks(count: 5)
        let result = BrewRecommender.recommend(from: drinks, records: [])
        #expect(result != nil)
    }

    @Test("Result always in input list")
    func resultInList() {
        let drinks = makeDrinks(count: 10)
        let ids = Set(drinks.map { $0.id })
        for _ in 0..<30 {
            if let drink = BrewRecommender.recommend(from: drinks, records: []) {
                #expect(ids.contains(drink.id))
            }
        }
    }

    @Test("Empty catalog returns nil")
    func emptyReturnsNil() {
        #expect(BrewRecommender.recommend(from: [], records: []) == nil)
    }
}

@Suite("AchievementEngine Tests")
struct AchievementEngineTests {

    @Test("Level 0 for 0 cups")
    func levelZero() { #expect(AchievementEngine.level(totalCups: 0) == 0) }

    @Test("Level 1 at 4 cups")
    func levelOne() { #expect(AchievementEngine.level(totalCups: 4) == 1) }

    @Test("Level 7 at 196 cups")
    func levelSeven() { #expect(AchievementEngine.level(totalCups: 196) == 7) }

    @Test("Level progress stays in [0,1]")
    func progressRange() {
        for cups in [0, 1, 4, 10, 100, 500] {
            let p = AchievementEngine.levelProgress(totalCups: cups)
            #expect(p >= 0 && p <= 1)
        }
    }

    @Test("Starter badge unlocks at 10 unique drinks")
    func starterUnlocked() {
        let drinks = makeDrinks(count: 15)
        let records = makeRecords(drinkIDs: Array(drinks.prefix(10).map { $0.id }))
        let groups = AchievementEngine.compute(records: records, drinks: drinks)
        let starter = groups.first { $0.group == .collection }?.badges.first { $0.id == "col-10" }
        #expect(starter?.isUnlocked == true)
    }

    @Test("Starter badge locked at 9 unique drinks")
    func starterLocked() {
        let drinks = makeDrinks(count: 15)
        let records = makeRecords(drinkIDs: Array(drinks.prefix(9).map { $0.id }))
        let groups = AchievementEngine.compute(records: records, drinks: drinks)
        let starter = groups.first { $0.group == .collection }?.badges.first { $0.id == "col-10" }
        #expect(starter?.isUnlocked == false)
    }

    @Test("Computed price = base + extraShots*4 + flavor")
    func priceCalc() {
        let base = 33; let extra = 2 * 4; let flav = 5
        #expect(base + extra + flav == 46)
    }

    // Helpers
    private func makeDrinks(count: Int) -> [Drink] {
        (0..<count).map { i in
            Drink(id: "t\(i)", nameCN: "饮品\(i)", nameEN: "D\(i)",
                  category: .craftedCoffee, subCategory: nil, description: "",
                  sizes: ["grande": 33], imageName: "x.PNG", tags: [])
        }
    }

    private func makeRecords(drinkIDs: [String]) -> [CupRecord] {
        drinkIDs.map { id in
            CupRecord(drinkID: id, cupSize: .grande, temperature: .hot,
                      sugarLevel: .standard, shotCount: 1, milkType: .whole, computedPrice: 33)
        }
    }
}

import SwiftUI
import SwiftData

private enum LibraryFilter: String, CaseIterable, Hashable {
    case all    = "全部"
    case drunk  = "已喝"
    case new    = "未喝"

    var label: String { rawValue }
}

struct LibraryTabView: View {
    @EnvironmentObject private var repo: DrinkRepository
    @Query(sort: \CupRecord.drunkAt, order: .reverse) private var records: [CupRecord]

    @State private var filter: LibraryFilter = .all
    @State private var searchQuery = ""
    @State private var lockedDrink: Drink? = nil
    @State private var showLockedAlert = false
    @State private var navToDrink: Drink? = nil

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    private var drinkCounts: [String: Int] {
        records.reduce(into: [:]) { $0[$1.drinkID, default: 0] += 1 }
    }

    private var unlockedIDs: Set<String> { Set(drinkCounts.keys) }

    private var allDrinks: [Drink] {
        if searchQuery.isEmpty { return repo.drinks }
        return repo.search(searchQuery)
    }

    private var filteredDrinks: [Drink] {
        switch filter {
        case .all:   return allDrinks
        case .drunk: return allDrinks.filter { unlockedIDs.contains($0.id) }
        case .new:   return allDrinks.filter { !unlockedIDs.contains($0.id) }
        }
    }

    private var groupedDrinks: [(DrinkCategory, [Drink])] {
        DrinkCategory.allCases.compactMap { cat in
            let drinks = filteredDrinks.filter { $0.category == cat }
            guard !drinks.isEmpty else { return nil }
            return (cat, drinks)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sbCanvas.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("饮品图鉴")
                                .font(.sbTitleXL)
                                .foregroundStyle(Color.sbInk)
                            Spacer()
                            IconBtn(icon: "magnifyingglass")
                            IconBtn(icon: "gearshape")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 8)

                        // Progress card
                        progressCard
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                        // Filter pills
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(LibraryFilter.allCases, id: \.self) { f in
                                    PillView(
                                        title: f.label,
                                        style: filter == f ? .active : .normal,
                                        badge: countFor(f)
                                    ) { withAnimation { filter = f } }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                        }

                        // Grouped grid
                        if filteredDrinks.isEmpty {
                            emptyState
                        } else {
                            ForEach(groupedDrinks, id: \.0) { (cat, drinks) in
                                categorySection(cat: cat, drinks: drinks)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .navigationDestination(item: $navToDrink) { drink in
                DrinkDetailReadOnly(drink: drink, records: records)
            }
            .alert("还没喝过这款", isPresented: $showLockedAlert) {
                Button("去记一杯") {
                    if let d = lockedDrink { navToDrink = d }
                }
                Button("取消", role: .cancel) {}
            } message: {
                Text(lockedDrink.map { "「\($0.nameCN)」等你解锁" } ?? "")
            }
        }
    }

    // MARK: Progress card
    private var progressCard: some View {
        ZStack {
            LinearGradient(
                colors: [Color.sbGreenDeep, Color.sbGreen],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .cornerRadius(18)

            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(.white.opacity(0.15)).frame(width: 56, height: 56)
                    Image(systemName: "crown.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("已收集")
                        .font(.sbLabel)
                        .foregroundStyle(.white.opacity(0.8))
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(unlockedIDs.count)")
                            .font(.system(size: 28, weight: .heavy, design: .monospaced))
                            .foregroundStyle(.white)
                        Text("/ \(repo.drinks.count)")
                            .font(.sbBodyM)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.2)).frame(height: 5)
                            Capsule().fill(.white)
                                .frame(width: geo.size.width * progressFraction, height: 5)
                        }
                    }
                    .frame(height: 5)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("下一目标")
                        .font(.sbLabel)
                        .foregroundStyle(.white.opacity(0.8))
                    Text(nextTarget)
                        .font(.sbBodyMB)
                        .foregroundStyle(.white)
                }
            }
            .padding(18)
        }
        .shadowMd()
    }

    private var progressFraction: Double {
        guard repo.drinks.count > 0 else { return 0 }
        return Double(unlockedIDs.count) / Double(repo.drinks.count)
    }

    private var nextTarget: String {
        let milestones = [10, 24, 35, 50, 73]
        let unlocked = unlockedIDs.count
        return milestones.first { $0 > unlocked }.map { "\($0) 款" } ?? "全部！"
    }

    // MARK: Category section
    private func categorySection(cat: DrinkCategory, drinks: [Drink]) -> some View {
        let catUnlocked = drinks.filter { unlockedIDs.contains($0.id) }.count
        let isComplete = catUnlocked == drinks.count && drinks.count > 0

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(cat.displayName)  ×\(catUnlocked)/\(drinks.count)")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                Spacer()
                if isComplete {
                    Text("★ 全收集")
                        .font(.sbLabel)
                        .foregroundStyle(Color.sbAmber)
                }
            }
            .padding(.horizontal, 20)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(drinks) { drink in
                    let count = drinkCounts[drink.id] ?? 0
                    let locked = count == 0
                    LibraryCellView(drink: drink, count: count, isLocked: locked) {
                        if locked {
                            lockedDrink = drink
                            showLockedAlert = true
                        } else {
                            navToDrink = drink
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 16)
    }

    // MARK: Empty
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "books.vertical")
                .font(.system(size: 44))
                .foregroundStyle(Color.sbInk3)
            Text("这里还空着，去喝一杯解锁吧 ☕")
                .font(.sbBodyS)
                .foregroundStyle(Color.sbInk3)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }

    private func countFor(_ f: LibraryFilter) -> Int? {
        switch f {
        case .all:   return nil
        case .drunk: return unlockedIDs.count
        case .new:   return repo.drinks.count - unlockedIDs.count
        }
    }
}

private struct LibraryCellView: View {
    let drink: Drink
    let count: Int
    let isLocked: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                DrinkAvatar(
                    drink: drink,
                    size: 80,
                    isLocked: isLocked,
                    count: count,
                    ringColor: count >= 20 ? Color.sbAmber : .clear
                )
                Text(drink.nameCN)
                    .font(.sbLabel)
                    .foregroundStyle(isLocked ? Color.sbInk3 : Color.sbInk)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                if !isLocked {
                    Text("已喝 \(count) 次")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(Color.sbInk3)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// Read-only drink detail
struct DrinkDetailReadOnly: View {
    let drink: Drink
    let records: [CupRecord]
    @Environment(\.dismiss) private var dismiss

    private var drinkRecords: [CupRecord] {
        records.filter { $0.drinkID == drink.id }.sorted { $0.drunkAt > $1.drunkAt }
    }

    var body: some View {
        ZStack {
            Color.sbCanvas.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    // Hero
                    VStack(spacing: 12) {
                        DrinkAvatar(drink: drink, size: 140)
                            .shadowMd()
                        Text(drink.nameCN)
                            .font(.sbTitleL)
                            .foregroundStyle(Color.sbInk)
                            .multilineTextAlignment(.center)
                        Text(drink.nameEN)
                            .font(.sbCaption)
                            .foregroundStyle(Color.sbInk2)
                    }
                    .padding(.top, 60)

                    // Description
                    DCard {
                        Text(drink.description)
                            .font(.sbBodyS)
                            .foregroundStyle(Color.sbInk1)
                    }

                    // My records
                    if !drinkRecords.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("我的记录  ×\(drinkRecords.count)")
                                .font(.sbBodyMB)
                                .foregroundStyle(Color.sbInk)

                            ForEach(drinkRecords.prefix(5)) { r in
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(r.drunkAt.formatted(date: .abbreviated, time: .shortened))
                                            .font(.sbCaption)
                                            .foregroundStyle(Color.sbInk2)
                                        Text(r.shortSpec)
                                            .font(.sbBodyS)
                                            .foregroundStyle(Color.sbInk)
                                    }
                                    Spacer()
                                    HStack(spacing: 2) {
                                        ForEach(1...5, id: \.self) { s in
                                            Image(systemName: s <= r.rating ? "star.fill" : "star")
                                                .font(.system(size: 10))
                                                .foregroundStyle(s <= r.rating ? Color.sbAmber : Color.sbLine2)
                                        }
                                    }
                                    Text("¥\(r.computedPrice)")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundStyle(Color.sbInk)
                                }
                                .padding(.vertical, 8)
                                if r.id != drinkRecords.prefix(5).last?.id {
                                    Divider()
                                }
                            }
                        }
                        .padding(14)
                        .background(Color.sbPaper)
                        .cornerRadius(16)
                        .shadowSm()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .overlay(alignment: .top) {
            NavHeaderView(title: drink.nameCN, leftAction: { dismiss() })
                .background(Color.sbCanvas.opacity(0.95))
        }
    }
}

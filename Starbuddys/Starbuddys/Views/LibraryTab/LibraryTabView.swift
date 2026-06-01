import SwiftUI
import SwiftData

private enum LibraryFilter: String, CaseIterable, Hashable {
    case all    = "全部"
    case drunk  = "已喝"
    case new    = "未喝"

    var label: String { rawValue }
}

private enum QuickFilter: Hashable {
    case category(DrinkCategory)
    case customCategory(String)

    var label: String {
        switch self {
        case .category(let c):       return c.displayName
        case .customCategory(let s): return s
        }
    }
}

struct LibraryTabView: View {
    @EnvironmentObject private var repo: DrinkRepository
    @Query(sort: \CupRecord.drunkAt, order: .reverse) private var records: [CupRecord]

    @State private var filter: LibraryFilter = .all
    @State private var brand: BrandType = .starbucks
    @State private var quickFilter: QuickFilter? = nil
    @State private var searchQuery = ""
    @State private var lockedDrink: Drink? = nil
    @State private var showLockedAlert = false
    @State private var navToDrink: Drink? = nil
    @State private var recordDrink: Drink? = nil
    @State private var showAddDrink = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    private var drinkCounts: [String: Int] {
        records.reduce(into: [:]) { $0[$1.drinkID, default: 0] += 1 }
    }

    private var unlockedIDs: Set<String> { Set(drinkCounts.keys) }

    private var brandDrinks: [Drink] {
        repo.drinks(brand: brand)
    }

    private var brandUnlockedIDs: Set<String> {
        Set(brandDrinks.map { $0.id }).intersection(unlockedIDs)
    }

    private var allDrinks: [Drink] {
        if searchQuery.isEmpty { return brandDrinks }
        return repo.search(searchQuery).filter { $0.brand == brand }
    }

    private var filteredDrinks: [Drink] {
        switch filter {
        case .all:   return allDrinks
        case .drunk: return allDrinks.filter { unlockedIDs.contains($0.id) }
        case .new:   return allDrinks.filter { !unlockedIDs.contains($0.id) }
        }
    }

    private var quickFilterOptions: [(label: String, filter: QuickFilter)] {
        var opts = DrinkCategory.categories(for: brand)
            .filter { cat in allDrinks.contains(where: { $0.category == cat && $0.customCategoryName == nil }) }
            .map { (label: $0.displayName, filter: QuickFilter.category($0)) }
        // 追加用户自定义品类的快速筛选选项
        let customNames = customCategoryNames(from: allDrinks)
        for name in customNames {
            opts.append((label: name, filter: .customCategory(name)))
        }
        return opts
    }

    /// 提取当前品牌下的用户自定义品类名（去重保序）
    private func customCategoryNames(from drinks: [Drink]) -> [String] {
        drinks
            .filter { $0.isUserCreated && $0.customCategoryName != nil }
            .compactMap { $0.customCategoryName }
            .reduce(into: [String]()) { if !$0.contains($1) { $0.append($1) } }
    }

    private var sections: [DrinkSection] {
        switch quickFilter {
        case .none:
            return buildSections(from: filteredDrinks)
        case .some(.category(let cat)):
            let drinks = filteredDrinks.filter { $0.category == cat && $0.customCategoryName == nil }
            return drinks.isEmpty ? [] : [DrinkSection(id: cat.rawValue, title: cat.displayName, drinks: drinks)]
        case .some(.customCategory(let name)):
            let drinks = filteredDrinks.filter { $0.customCategoryName == name }
            return drinks.isEmpty ? [] : [DrinkSection(id: "custom_\(name)", title: name, drinks: drinks)]
        }
    }

    private func buildSections(from drinks: [Drink]) -> [DrinkSection] {
        // 标准品类分区（seed 饮品 + 使用标准品类的用户饮品）
        var result = DrinkCategory.categories(for: brand).compactMap { cat -> DrinkSection? in
            let d = drinks.filter { $0.category == cat && $0.customCategoryName == nil }
            guard !d.isEmpty else { return nil }
            return DrinkSection(id: cat.rawValue, title: cat.displayName, drinks: d)
        }
        // 用户自定义品类分区（追加在最后）
        let customNames = customCategoryNames(from: drinks)
        for name in customNames {
            let d = drinks.filter { $0.customCategoryName == name }
            result.append(DrinkSection(id: "custom_\(name)", title: name, drinks: d))
        }
        return result
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
                            // 新增饮品胶囊按钮，右对齐
                            Button { showAddDrink = true } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 11, weight: .semibold))
                                    Text("新增饮品")
                                        .font(.sbCaption)
                                }
                                .foregroundStyle(Color.sbInk1)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.sbLine2, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 8)

                        // Brand selector（各品牌激活色独立）
                        HStack(spacing: 8) {
                            ForEach(BrandType.allCases, id: \.self) { b in
                                Button {
                                    withAnimation { brand = b }
                                } label: {
                                    Text(b.displayName)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(brand == b ? .white : Color.sbInk1)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 9)
                                        .background(brand == b ? b.brandColors.dark : Color.sbLine.opacity(0.5))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)

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

                        // Category quick-filter
                        if quickFilterOptions.count > 1 {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    PillView(
                                        title: "全部",
                                        style: quickFilter == nil ? .soft : .normal
                                    ) { withAnimation { quickFilter = nil } }
                                    ForEach(quickFilterOptions, id: \.filter) { opt in
                                        PillView(
                                            title: opt.label,
                                            style: quickFilter == opt.filter ? .soft : .normal
                                        ) { withAnimation { quickFilter = quickFilter == opt.filter ? nil : opt.filter } }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 4)
                            }
                        }

                        // Grouped grid
                        if sections.isEmpty {
                            emptyState
                        } else {
                            ForEach(sections) { section in
                                sectionView(section)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .onChange(of: brand) { _, _ in quickFilter = nil }
            .navigationDestination(item: $navToDrink) { drink in
                DrinkDetailReadOnly(drink: drink, records: records)
            }
            .sheet(isPresented: $showAddDrink) {
                DrinkEditView(mode: .create(brand: brand))
                    .environmentObject(repo)
            }
            .alert("还没喝过这款", isPresented: $showLockedAlert) {
                Button("去记一杯") {
                    if let d = lockedDrink { recordDrink = d }
                }
                Button("取消", role: .cancel) {}
            } message: {
                Text(lockedDrink.map { "「\($0.nameCN)」等你解锁" } ?? "")
            }
            .sheet(item: $recordDrink) { drink in
                NavigationStack {
                    DetailPage(
                        drink: drink,
                        prefill: nil,
                        allRecords: records,
                        onSaved: { _ in recordDrink = nil },
                        onCancel: { recordDrink = nil }
                    )
                }
            }
        }
    }

    // MARK: Progress card
    private var progressCard: some View {
        ZStack {
            LinearGradient(
                colors: [brand.brandColors.dark, brand.brandColors.light],
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
                    Text("已收集 · \(brand.displayName)")
                        .font(.sbLabel)
                        .foregroundStyle(.white.opacity(0.8))
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(brandUnlockedIDs.count)")
                            .font(.system(size: 28, weight: .heavy, design: .monospaced))
                            .foregroundStyle(.white)
                        Text("/ \(brandDrinks.count)")
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
        guard brandDrinks.count > 0 else { return 0 }
        return Double(brandUnlockedIDs.count) / Double(brandDrinks.count)
    }

    private var nextTarget: String {
        let unlocked = brandUnlockedIDs.count
        let total    = brandDrinks.count
        // 固定里程碑过滤掉超过品牌总数的节点，再追加 total 作为终点
        let milestones = [2, 5, 10, 15, 20, 30, 40, 50].filter { $0 < total } + [total]
        return milestones.first { $0 > unlocked }.map { "\($0) 款" } ?? "全部！"
    }

    // MARK: Section view
    @ViewBuilder
    private func sectionView(_ section: DrinkSection) -> some View {
        let unlocked = section.drinks.filter { unlockedIDs.contains($0.id) }.count
        let isComplete = unlocked == section.drinks.count && !section.drinks.isEmpty

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(section.title)  \(unlocked)/\(section.drinks.count)")
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

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(section.drinks) { drink in
                    let count = drinkCounts[drink.id] ?? 0
                    let locked = count == 0 && !drink.isUserCreated
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
        case .drunk: return brandUnlockedIDs.count
        case .new:   return brandDrinks.count - brandUnlockedIDs.count
        }
    }
}

private struct DrinkSection: Identifiable {
    let id: String
    let title: String
    let drinks: [Drink]
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .buttonStyle(.plain)
    }
}

// Read-only drink detail
struct DrinkDetailReadOnly: View {
    let drink: Drink
    let records: [CupRecord]
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var repo: DrinkRepository

    @State private var selectedRecord: CupRecord? = nil
    @State private var showEdit = false

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
                                Button {
                                    selectedRecord = r
                                } label: {
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
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(Color.sbInk3)
                                    }
                                    .padding(.vertical, 8)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
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
            NavHeaderView(
                title: drink.nameCN,
                leftAction: { dismiss() },
                rightContent: drink.isUserCreated
                    ? AnyView(
                        Button("编辑") { showEdit = true }
                            .font(.sbBodyMB)
                            .foregroundStyle(Color.sbInk)
                      )
                    : nil
            )
            .background(Color.sbCanvas.opacity(0.95))
        }
        .sheet(isPresented: $showEdit) {
            DrinkEditView(mode: .edit(drink))
                .environmentObject(repo)
        }
        .navigationDestination(item: $selectedRecord) { record in
            RecordDetailView(record: record)
                .environmentObject(repo)
        }
    }
}

#Preview("饮品库 Tab") {
    LibraryTabView()
        .environmentObject(DrinkRepository.shared)
        .modelContainer(for: CupRecord.self, inMemory: true)
}

import SwiftUI

private enum PickerFilter: Hashable {
    case popular
    case category(DrinkCategory)

    var label: String {
        switch self {
        case .popular:           return "热门"
        case .category(let c):   return c.displayName
        }
    }
}

struct DrinkPickerSheet: View {
    let records: [CupRecord]
    var onSelect: (Drink) -> Void

    @EnvironmentObject private var repo: DrinkRepository
    @State private var query = ""
    @State private var filter: PickerFilter = .popular
    @State private var selected: Drink? = nil
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    private var drinkCounts: [String: Int] {
        records.reduce(into: [:]) { $0[$1.drinkID, default: 0] += 1 }
    }

    private var popularDrinkIDs: [String] {
        let sorted = drinkCounts.sorted { $0.value > $1.value }
        return Array(sorted.prefix(9).map { $0.key })
    }

    private var filteredDrinks: [Drink] {
        var base: [Drink]
        if !query.isEmpty {
            base = repo.search(query)
        } else {
            switch filter {
            case .popular:
                let popularSet = Set(popularDrinkIDs)
                base = repo.drinks.filter { popularSet.contains($0.id) }
                if base.isEmpty { base = Array(repo.drinks.prefix(9)) }
            case .category(let cat):
                base = repo.drinks(for: cat)
            }
        }
        return base
    }

    private var filterOptions: [(label: String, value: PickerFilter, count: Int?)] {
        var opts: [(String, PickerFilter, Int?)] = [("热门", .popular, nil)]
        for cat in DrinkCategory.allCases {
            opts.append((cat.displayName, .category(cat), nil))
        }
        return opts
    }

    var body: some View {
        VStack(spacing: 0) {
            // Handle + title
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.sbLine2)
                    .frame(width: 36, height: 4)
                    .padding(.top, 12)

                HStack {
                    Text("选一杯")
                        .font(.sbTitleM)
                        .foregroundStyle(Color.sbInk)
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color.sbInk2)
                            .frame(width: 32, height: 32)
                            .background(Color.sbLine.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 10)
            }

            // Search
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.sbInk3)
                TextField("搜咖啡名 / 系列", text: $query)
                    .font(.sbBodyM)
                if !query.isEmpty {
                    Button { query = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.sbInk3)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.sbCream)
            .cornerRadius(12)
            .padding(.horizontal, 20)

            // Category pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filterOptions, id: \.value) { opt in
                        PillView(
                            title: opt.label,
                            style: filter == opt.value ? .active : .normal
                        ) { withAnimation { filter = opt.value } }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }

            Divider().padding(.horizontal, 20)

            // Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(filteredDrinks) { drink in
                        DrinkPickerCell(
                            drink: drink,
                            count: drinkCounts[drink.id] ?? 0,
                            isSelected: selected?.id == drink.id
                        ) { selected = drink }
                    }
                }
                .padding(20)

                if filteredDrinks.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "cup.and.saucer")
                            .font(.system(size: 36))
                            .foregroundStyle(Color.sbInk3)
                        Text("这里还空着，去喝一杯解锁吧 ☕")
                            .font(.sbBodyS)
                            .foregroundStyle(Color.sbInk3)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                }
            }

            // Bottom CTA
            VStack(spacing: 0) {
                Divider()
                PrimaryButton(
                    title: selected != nil ? "选好了 · 下一步 →" : "请先选一款",
                    disabled: selected == nil
                ) {
                    if let d = selected { onSelect(d) }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .background(Color.sbPaper)
        .presentationDetents([.fraction(0.75), .large])
        .presentationDragIndicator(.hidden)
    }
}

private struct DrinkPickerCell: View {
    let drink: Drink
    let count: Int
    let isSelected: Bool
    var onTap: () -> Void

    @State private var scale: CGFloat = 1.0

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { scale = 0.95 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { scale = 1.02 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring()) { scale = 1.0 }
                }
            }
            onTap()
        } label: {
            VStack(spacing: 6) {
                DrinkAvatar(drink: drink, size: 72, count: count)
                    .overlay {
                        if isSelected {
                            Circle()
                                .strokeBorder(Color.sbGreenDeep, lineWidth: 2.5)
                                .frame(width: 76, height: 76)
                        }
                    }
                Text(drink.nameCN)
                    .font(.sbLabel)
                    .foregroundStyle(Color.sbInk)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .scaleEffect(scale)
        }
        .buttonStyle(.plain)
    }
}

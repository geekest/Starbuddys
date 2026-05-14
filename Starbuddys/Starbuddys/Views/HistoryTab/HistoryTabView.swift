import SwiftUI
import SwiftData

struct HistoryTabView: View {
    @Query(sort: \CupRecord.drunkAt, order: .reverse) private var records: [CupRecord]
    @EnvironmentObject private var repo: DrinkRepository

    @State private var displayYear:  Int
    @State private var displayMonth: Int

    init() {
        let c = Calendar.current
        _displayYear  = State(initialValue: c.component(.year,  from: Date()))
        _displayMonth = State(initialValue: c.component(.month, from: Date()))
    }

    private var monthRecords: [CupRecord] {
        let cal = Calendar.current
        return records.filter {
            let c = cal.dateComponents([.year, .month], from: $0.drunkAt)
            return c.year == displayYear && c.month == displayMonth
        }
    }

    private var recordsByDay: [Int: [CupRecord]] {
        let cal = Calendar.current
        return Dictionary(grouping: monthRecords) {
            cal.component(.day, from: $0.drunkAt)
        }
    }

    private var monthName: String {
        "\(displayMonth) 月"
    }

    private var totalSpent: Int { monthRecords.reduce(0) { $0 + $1.computedPrice } }
    private var streak: Int { computeStreak() }
    private var favoriteDrink: (Drink, Int)? { computeFavorite() }

    // Calendar layout
    private var firstWeekday: Int {
        let comps = DateComponents(year: displayYear, month: displayMonth, day: 1)
        let cal = Calendar(identifier: .gregorian)
        var adjusted = (cal.date(from: comps).flatMap { cal.component(.weekday, from: $0) } ?? 2) - 2
        if adjusted < 0 { adjusted += 7 }
        return adjusted
    }

    private var daysInMonth: Int {
        let cal = Calendar.current
        let comps = DateComponents(year: displayYear, month: displayMonth)
        return cal.range(of: .day, in: .month, for: cal.date(from: comps)!)?.count ?? 30
    }

    private var today: Int {
        let cal = Calendar.current
        let c = cal.dateComponents([.year, .month, .day], from: Date())
        guard c.year == displayYear && c.month == displayMonth else { return -1 }
        return c.day ?? -1
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sbCanvas.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        // Custom nav header
                        HStack {
                            HStack(spacing: 4) {
                                Text("\(displayYear)")
                                    .font(.sbBodyMB)
                                    .foregroundStyle(Color.sbInk1)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color.sbInk2)
                            }
                            Spacer()
                            Text("历史")
                                .font(.sbTitleS)
                                .foregroundStyle(Color.sbInk)
                            Spacer()
                            IconBtn(icon: "square.and.arrow.up")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)

                        // Month nav
                        HStack {
                            Button { shiftMonth(-1) } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(Color.sbInk1)
                                    .frame(width: 36, height: 36)
                            }
                            Spacer()
                            Text(monthName)
                                .font(.sbTitleM)
                                .foregroundStyle(Color.sbInk)
                            Spacer()
                            Button { shiftMonth(1) } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(Color.sbInk1)
                                    .frame(width: 36, height: 36)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)

                        // Weekday row
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                            ForEach(["一","二","三","四","五","六","日"], id: \.self) { d in
                                Text(d)
                                    .font(.sbLabel)
                                    .foregroundStyle(Color.sbInk3)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                            }
                        }
                        .padding(.horizontal, 16)

                        // Calendar grid
                        calendarGrid
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)

                        // Summary cards
                        if !monthRecords.isEmpty {
                            summaryCards.padding(.horizontal, 20)
                            if let (drink, count) = favoriteDrink {
                                favoriteCard(drink: drink, count: count)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 12)
                            }
                        } else {
                            emptyState
                        }

                        // Detail list
                        if !monthRecords.isEmpty {
                            detailList
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                        }
                    }
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: Calendar grid
    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 2) {
            // Empty cells for offset
            ForEach(0..<firstWeekday, id: \.self) { _ in Color.clear.aspectRatio(1, contentMode: .fill) }

            // Day cells
            ForEach(1...daysInMonth, id: \.self) { day in
                let dayRecords = recordsByDay[day] ?? []
                let isToday = day == today
                VStack(spacing: 2) {
                    ZStack {
                        Circle()
                            .fill(isToday ? Color.sbGreenDeep : .clear)
                            .frame(width: 30, height: 30)
                        Text("\(day)")
                            .font(.system(size: 13, weight: isToday ? .heavy : (dayRecords.isEmpty ? .regular : .bold),
                                          design: .monospaced))
                            .foregroundStyle(isToday ? .white : (dayRecords.isEmpty ? Color.sbInk3 : Color.sbInk))
                    }

                    if !dayRecords.isEmpty {
                        HStack(spacing: -6) {
                            ForEach(Array(dayRecords.prefix(2).enumerated()), id: \.0) { idx, r in
                                if let drink = repo.drink(id: r.drinkID) {
                                    DrinkAvatar(drink: drink, size: 18)
                                        .overlay(Circle().strokeBorder(.white, lineWidth: 1))
                                        .zIndex(Double(2 - idx))
                                }
                            }
                            if dayRecords.count > 2 {
                                Text("+\(dayRecords.count - 2)")
                                    .font(.system(size: 7))
                                    .foregroundStyle(Color.sbInk3)
                            }
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fill)
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: Summary cards
    private var summaryCards: some View {
        HStack(spacing: 10) {
            ForEach([
                ("杯数", "\(monthRecords.count)", "杯"),
                ("花费", "\(totalSpent)", "¥"),
                ("连击", "\(streak)", "天"),
            ], id: \.0) { label, value, unit in
                DCardBorder {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(label)
                            .font(.sbCaption)
                            .foregroundStyle(Color.sbInk2)
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(value)
                                .font(.system(size: 22, weight: .heavy, design: .monospaced))
                                .foregroundStyle(Color.sbGreenDeep)
                            Text(unit)
                                .font(.sbCaption)
                                .foregroundStyle(Color.sbInk2)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: Favorite card
    private func favoriteCard(drink: Drink, count: Int) -> some View {
        DCardBorder {
            HStack(spacing: 12) {
                DrinkAvatar(drink: drink, size: 48)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(displayMonth) 月最爱")
                        .font(.sbLabel)
                        .foregroundStyle(Color.sbInk2)
                    Text("\(drink.nameCN) · \(count) 杯")
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk)
                }
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundStyle(Color.sbRose)
            }
        }
    }

    // MARK: Detail list
    private var detailList: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("明细")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                Spacer()
                Text("按时间倒序")
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk3)
            }
            .padding(.bottom, 8)

            let shown = Array(monthRecords.prefix(5))
            ForEach(Array(shown.enumerated()), id: \.element.id) { idx, record in
                if let drink = repo.drink(id: record.drinkID) {
                    recordRow(record: record, drink: drink)
                    if idx < shown.count - 1 {
                        Divider().padding(.leading, 60)
                    }
                }
            }

            if monthRecords.count > 5 {
                Text("查看 \(displayMonth) 月全部 \(monthRecords.count) 条 →")
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk3)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 14)
            }
        }
        .padding(14)
        .background(Color.sbPaper)
        .cornerRadius(16)
        .shadowSm()
    }

    private func recordRow(record: CupRecord, drink: Drink) -> some View {
        HStack(spacing: 12) {
            DrinkAvatar(drink: drink, size: 48)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    BrandBadge(brand: drink.brand, size: 9)
                    Text(record.drunkAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.sbLabel)
                        .foregroundStyle(Color.sbInk2)
                }
                Text(drink.nameCN)
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                    .lineLimit(1)
                Text(record.shortSpec)
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk2)
                if let note = record.note, !note.isEmpty {
                    Text("「\(note)」")
                        .font(.sbCaption)
                        .foregroundStyle(Color.sbGreenDeep)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("¥\(record.computedPrice)")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.sbInk)
                HStack(spacing: 1) {
                    ForEach(1...5, id: \.self) { s in
                        Image(systemName: s <= record.rating ? "star.fill" : "star")
                            .font(.system(size: 10))
                            .foregroundStyle(s <= record.rating ? Color.sbAmber : Color.sbLine2)
                    }
                }
            }
        }
        .padding(.vertical, 14)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "calendar.badge.minus")
                .font(.system(size: 40))
                .foregroundStyle(Color.sbInk3)
            Text("这个月还没记录")
                .font(.sbBodyM)
                .foregroundStyle(Color.sbInk2)
            Text("翻翻其他月份?")
                .font(.sbCaption)
                .foregroundStyle(Color.sbInk3)
        }
        .padding(.top, 40)
    }

    // MARK: Helpers
    private func shiftMonth(_ delta: Int) {
        let comps = DateComponents(year: displayYear, month: displayMonth + delta)
        let cal = Calendar.current
        if let date = cal.date(from: comps) {
            let c = cal.dateComponents([.year, .month], from: date)
            displayYear  = c.year  ?? displayYear
            displayMonth = c.month ?? displayMonth
        }
    }

    private func computeStreak() -> Int {
        var s = 0
        let cal = Calendar.current
        let days = Set(monthRecords.map { cal.component(.day, from: $0.drunkAt) })
        var d = today > 0 ? today : daysInMonth
        while days.contains(d) { s += 1; d -= 1 }
        return s
    }

    private func computeFavorite() -> (Drink, Int)? {
        let counts: [String: Int] = monthRecords.reduce(into: [:]) { $0[$1.drinkID, default: 0] += 1 }
        guard let (id, count) = counts.max(by: { $0.value < $1.value }),
              let drink = repo.drink(id: id) else { return nil }
        return (drink, count)
    }
}

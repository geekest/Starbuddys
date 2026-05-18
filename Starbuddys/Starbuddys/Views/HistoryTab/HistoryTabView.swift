import SwiftUI
import SwiftData

// MARK: - Calendar cell model
private enum CalCell: Identifiable {
    case empty(Int)
    case day(Int)

    var id: String {
        switch self {
        case .empty(let i): return "e\(i)"
        case .day(let d):   return "d\(d)"
        }
    }
}

// MARK: - Month full list sheet
struct MonthAllRecordsView: View {
    let year: Int
    let month: Int
    let records: [CupRecord]
    @EnvironmentObject private var repo: DrinkRepository
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sbCanvas.ignoresSafeArea()
                if records.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "calendar.badge.minus")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.sbInk3)
                        Text("本月暂无记录")
                            .font(.sbBodyM)
                            .foregroundStyle(Color.sbInk2)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(records.enumerated()), id: \.element.id) { idx, record in
                                if let drink = repo.drink(id: record.drinkID) {
                                    recordRow(record: record, drink: drink)
                                        .padding(.horizontal, 20)
                                    if idx < records.count - 1 {
                                        Divider().padding(.leading, 80)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .background(Color.sbPaper)
                        .cornerRadius(16)
                        .shadowSm()
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("\(month) 月全部记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("关闭") { dismiss() }
                        .foregroundStyle(Color.sbGreenDeep)
                }
            }
        }
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
}

// MARK: - History tab
struct HistoryTabView: View {
    @Query(sort: \CupRecord.drunkAt, order: .reverse) private var records: [CupRecord]
    @EnvironmentObject private var repo: DrinkRepository

    @State private var displayYear:  Int
    @State private var displayMonth: Int
    @State private var selectedDay:  Int? = nil
    @State private var showYearPicker  = false
    @State private var showAllRecords  = false

    init() {
        let c = Calendar.current
        _displayYear  = State(initialValue: c.component(.year,  from: Date()))
        _displayMonth = State(initialValue: c.component(.month, from: Date()))
    }

    // MARK: Data helpers
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

    private var displayedRecords: [CupRecord] {
        guard let day = selectedDay else { return monthRecords }
        return recordsByDay[day] ?? []
    }

    private var totalSpent: Int { monthRecords.reduce(0) { $0 + $1.computedPrice } }
    private var streak: Int { computeStreak() }
    private var favoriteDrink: (Drink, Int)? { computeFavorite() }

    private var availableYears: [Int] {
        let cur = Calendar.current.component(.year, from: Date())
        return Array(((cur - 4)...cur).reversed())
    }

    // MARK: Calendar geometry
    private var firstWeekday: Int {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "zh_CN")
        let comps = DateComponents(year: displayYear, month: displayMonth, day: 1)
        guard let date = cal.date(from: comps) else { return 0 }
        // Sun=1 Mon=2 … Sat=7  →  Mon-first layout offset
        let wd = cal.component(.weekday, from: date)
        let offset = (wd - 2 + 7) % 7
        return offset
    }

    private var daysInMonth: Int {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "zh_CN")
        let comps = DateComponents(year: displayYear, month: displayMonth)
        guard let date = cal.date(from: comps),
              let range = cal.range(of: .day, in: .month, for: date) else { return 30 }
        return range.count
    }

    private var todayDay: Int {
        let cal = Calendar.current
        let c = cal.dateComponents([.year, .month, .day], from: Date())
        guard c.year == displayYear && c.month == displayMonth else { return -1 }
        return c.day ?? -1
    }

    private var calendarCells: [CalCell] {
        var cells: [CalCell] = (0..<firstWeekday).map { .empty($0) }
        cells += (1...daysInMonth).map { .day($0) }
        return cells
    }

    // MARK: Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.sbCanvas.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        navHeader
                        monthNav
                        weekdayRow
                        calendarGrid
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)

                        if !monthRecords.isEmpty {
                            summaryCards.padding(.horizontal, 20)
                            if let (drink, count) = favoriteDrink {
                                favoriteCard(drink: drink, count: count)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 12)
                            }
                            detailList
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                        } else {
                            emptyState
                        }
                    }
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showYearPicker) { yearPickerSheet }
            .sheet(isPresented: $showAllRecords) {
                MonthAllRecordsView(year: displayYear, month: displayMonth, records: monthRecords)
                    .environmentObject(repo)
            }
        }
    }

    // MARK: Nav header
    private var navHeader: some View {
        HStack {
            Button { showYearPicker = true } label: {
                HStack(spacing: 4) {
                    Text(verbatim: "\(displayYear)")
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk1)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.sbInk2)
                        .rotationEffect(showYearPicker ? .degrees(180) : .zero)
                        .animation(.easeInOut(duration: 0.2), value: showYearPicker)
                }
            }
            Spacer()
            Text("历史")
                .font(.sbTitleS)
                .foregroundStyle(Color.sbInk)
            Spacer()
            Color.clear.frame(width: 36, height: 36)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    // MARK: Month nav
    private var monthNav: some View {
        HStack {
            Button { shiftMonth(-1) } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.sbInk1)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Text("\(displayMonth) 月")
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
    }

    // MARK: Weekday row
    private var weekdayRow: some View {
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
    }

    // MARK: Calendar grid
    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 2) {
            ForEach(calendarCells) { cell in
                switch cell {
                case .empty:
                    Color.clear
                        .aspectRatio(1, contentMode: .fill)
                case .day(let day):
                    dayCell(day)
                }
            }
        }
    }

    private func dayCell(_ day: Int) -> some View {
        let dayRecords = recordsByDay[day] ?? []
        let isToday    = day == todayDay
        let isSelected = day == selectedDay

        return VStack(spacing: 2) {
            ZStack {
                if isToday {
                    Circle().fill(Color.sbGreenDeep).frame(width: 30, height: 30)
                } else if isSelected {
                    Circle().fill(Color.sbGreenDeep.opacity(0.12)).frame(width: 30, height: 30)
                    Circle().strokeBorder(Color.sbGreenDeep, lineWidth: 1.5).frame(width: 30, height: 30)
                }
                Text(verbatim: "\(day)")
                    .font(.system(
                        size: 13,
                        weight: (isToday || isSelected) ? .heavy : (dayRecords.isEmpty ? .regular : .bold),
                        design: .monospaced
                    ))
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
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.15)) {
                selectedDay = (selectedDay == day) ? nil : day
            }
        }
    }

    // MARK: Year picker sheet
    private var yearPickerSheet: some View {
        NavigationStack {
            List(availableYears, id: \.self) { year in
                Button {
                    displayYear  = year
                    selectedDay  = nil
                    showYearPicker = false
                } label: {
                    HStack {
                        Text(verbatim: "\(year) 年")
                            .foregroundStyle(Color.sbInk)
                        Spacer()
                        if year == displayYear {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.sbGreenDeep)
                        }
                    }
                }
            }
            .navigationTitle("选择年份")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") { showYearPicker = false }
                        .foregroundStyle(Color.sbGreenDeep)
                }
            }
        }
        .presentationDetents([.fraction(0.42)])
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
                if let day = selectedDay {
                    Text("\(displayMonth) 月 \(day) 日")
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk)
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) { selectedDay = nil }
                    } label: {
                        Text("查看全月")
                            .font(.sbCaption)
                            .foregroundStyle(Color.sbGreenDeep)
                    }
                } else {
                    Text("明细")
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk)
                    Spacer()
                    Text("按时间倒序")
                        .font(.sbCaption)
                        .foregroundStyle(Color.sbInk3)
                }
            }
            .padding(.bottom, 8)

            let toShow = displayedRecords
            if toShow.isEmpty {
                Text("当日暂无记录")
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk3)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                let shown = Array(toShow.prefix(5))
                ForEach(Array(shown.enumerated()), id: \.element.id) { idx, record in
                    if let drink = repo.drink(id: record.drinkID) {
                        recordRow(record: record, drink: drink)
                        if idx < shown.count - 1 {
                            Divider().padding(.leading, 60)
                        }
                    }
                }
                if toShow.count > 5 {
                    Button { showAllRecords = true } label: {
                        Text("查看 \(displayMonth) 月全部 \(toShow.count) 条 →")
                            .font(.sbCaption)
                            .foregroundStyle(Color.sbInk3)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 14)
                    }
                }
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

    // MARK: Empty state
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
            selectedDay  = nil
        }
    }

    private func computeStreak() -> Int {
        var s = 0
        let cal = Calendar.current
        let days = Set(monthRecords.map { cal.component(.day, from: $0.drunkAt) })
        var d = todayDay > 0 ? todayDay : daysInMonth
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

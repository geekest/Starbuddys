import SwiftUI
import SwiftData

private let availableFlavors: [FlavorAddon] = [
    .init(name: "焦糖风味糖浆",  count: 1, extraPrice: 0),
    .init(name: "香草风味糖浆",  count: 1, extraPrice: 0),
    .init(name: "榛果风味糖浆",  count: 1, extraPrice: 0),
    .init(name: "海盐奶盖",      count: 1, extraPrice: 5),
    .init(name: "淡奶油",        count: 1, extraPrice: 5),
    .init(name: "巧克力酱",      count: 1, extraPrice: 0),
    .init(name: "抹茶粉",        count: 1, extraPrice: 5),
    .init(name: "桂花糖浆",      count: 1, extraPrice: 5),
]

struct DetailPage: View {
    let drink: Drink
    var prefill: CupRecord?
    let allRecords: [CupRecord]
    var onSaved: (String) -> Void
    var onCancel: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    // Form state - Basic
    @State private var selectedSize: CupSize
    @State private var selectedTemp: Temperature
    @State private var selectedMilk: MilkType

    // Form state - Coffee specific
    @State private var selectedEspresso: EspressoType?
    @State private var espressoShots: Int?
    @State private var selectedFoam: FoamLevel?

    // Form state - Sweetness
    @State private var selectedSweetOption: SweetOption?
    @State private var selectedSweetPosition: SweetPosition?

    // Form state - Toppings
    @State private var selectedWhippedCream: WhippedCreamLevel?
    @State private var selectedFlavorSyrups: [FlavorSyrup] = []

    // Form state - Legacy
    @State private var selectedSugar: SugarLevel?
    @State private var shotCount: Int
    @State private var extraShots: Int
    @State private var selectedFlavors: [FlavorAddon]

    // Form state - User input
    @State private var customPrice: String = ""
    @State private var rating: Int
    @State private var note: String
    @State private var showFlavorPicker = false
    @State private var showDiscardAlert = false
    @State private var showPricePicker = false

    init(drink: Drink, prefill: CupRecord?, allRecords: [CupRecord], onSaved: @escaping (String) -> Void, onCancel: @escaping () -> Void) {
        self.drink = drink
        self.prefill = prefill
        self.allRecords = allRecords
        self.onSaved = onSaved
        self.onCancel = onCancel

        let (defSize, defTemp, _) = BrewRecommender.defaultConfig(for: drink)
        _selectedSize   = State(initialValue: prefill?.cupSize   ?? defSize)
        _selectedTemp   = State(initialValue: prefill?.temperature ?? defTemp)
        _selectedMilk   = State(initialValue: prefill?.milkType  ?? drink.defaultMilk)

        _selectedEspresso = State(initialValue: prefill?.espressoType)
        _espressoShots = State(initialValue: prefill?.espressoShots)
        _selectedFoam = State(initialValue: prefill?.foamLevel)

        _selectedSweetOption = State(initialValue: prefill?.sweetOption)
        _selectedSweetPosition = State(initialValue: prefill?.sweetPosition)

        _selectedWhippedCream = State(initialValue: prefill?.whippedCreamLevel)
        _selectedFlavorSyrups = State(initialValue: prefill?.flavorSyrups ?? [])

        _selectedSugar = State(initialValue: prefill?.sugarLevel)
        _shotCount = State(initialValue: prefill?.shotCount ?? 1)
        _extraShots = State(initialValue: prefill?.extraShots ?? 0)
        _selectedFlavors = State(initialValue: prefill?.flavors ?? [])

        _customPrice = State(initialValue: prefill?.customPrice.map(String.init) ?? "")
        _rating = State(initialValue: prefill?.rating ?? 4)
        _note = State(initialValue: prefill?.note ?? "")
    }

    private var isFirstTime: Bool {
        !allRecords.contains { $0.drinkID == drink.id }
    }

    private var computedPrice: Int {
        if let custom = Int(customPrice), custom > 0 {
            return custom
        }
        let base   = drink.sizePrices[selectedSize] ?? 0
        let extra  = extraShots * 4
        let flavExt = selectedFlavors.reduce(0) { $0 + $1.count * $1.extraPrice }
        return base + extra + flavExt
    }

    private var monthlyTotal: Int {
        let cal = Calendar.current
        let now = Date()
        return allRecords
            .filter {
                let c = cal.dateComponents([.year,.month], from: $0.drunkAt)
                let n = cal.dateComponents([.year,.month], from: now)
                return c.year == n.year && c.month == n.month
            }
            .reduce(0) { $0 + $1.computedPrice }
    }

    private var sizeOptions: [(label: String, sub: String?, value: CupSize, disabled: Bool)] {
        CupSize.allCases.map { size in
            (label: size.displayName, sub: size.ml, value: size, disabled: drink.sizePrices[size] == nil)
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.sbCanvas.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Hero
                    heroSection
                        .padding(.bottom, 24)

                    // Form sections
                    VStack(spacing: 20) {
                        sizeSection
                        tempSection
                        if drink.isCoffee { espressoSection }
                        milkSection
                        if drink.isCoffee { foamSection }
                        flavorSyrupSection
                        sweetSection
                        whippedCreamSection
                        if drink.isCoffee { shotSection }
                        priceSection
                        ratingSection
                        noteSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .scrollIndicators(.hidden)

            // Bottom CTA
            bottomBar
        }
        .navigationBarHidden(true)
        .overlay(alignment: .top) {
            NavHeaderView(
                title: "记一杯",
                leftAction: { showDiscardAlert = true },
                rightContent: AnyView(
                    Button {
                        // heart / favorite (MVP: UI only)
                    } label: {
                        Image(systemName: "heart")
                            .font(.system(size: 17))
                            .foregroundStyle(Color.sbInk1)
                            .frame(width: 36, height: 36)
                            .background(Color.sbLine.opacity(0.5))
                            .cornerRadius(12)
                    }
                )
            )
            .background(Color.sbCanvas.opacity(0.95))
        }
        .alert("确定放弃这次记录？", isPresented: $showDiscardAlert) {
            Button("放弃", role: .destructive) { onCancel() }
            Button("继续", role: .cancel) { }
        }
        .sheet(isPresented: $showFlavorPicker) {
            flavorPickerSheet
        }
    }

    // MARK: Hero
    private var heroSection: some View {
        VStack(spacing: 12) {
            DrinkAvatar(drink: drink, size: 168)
                .shadowMd()

            VStack(spacing: 4) {
                Text(drink.nameCN)
                    .font(.sbTitleL)
                    .foregroundStyle(Color.sbInk)
                    .multilineTextAlignment(.center)
                Text("\(drink.nameEN) · \(drink.category.displayName)")
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk2)

                HStack(spacing: 8) {
                    if isFirstTime {
                        label("第一次喝", fg: Color.sbAmber, bg: Color.sbAmberSoft)
                    }
                    label(Date().formatted("yyyy/MM/dd · a"), fg: Color.sbGreenDeep, bg: Color.sbGreenPale)
                }
                .padding(.top, 4)
            }
        }
        .padding(.top, 60)
        .padding(.horizontal, 20)
    }

    // MARK: Form sections
    private var sizeSection: some View {
        formSection("杯型") {
            SBSegmentedPicker(options: sizeOptions, selection: $selectedSize)
        }
    }

    private var tempSection: some View {
        formSection("温度") {
            ChipGroup(
                options: Temperature.allCases.map { ($0.rawValue, $0) },
                selection: $selectedTemp
            )
        }
    }

    private var sugarSection: some View {
        formSection("糖度") {
            ChipGroup(
                options: SugarLevel.allCases.map { ($0.rawValue, $0) },
                selection: $selectedSugar
            )
        }
    }

    private var espressoSection: some View {
        formSection("浓缩咖啡") {
            VStack(spacing: 12) {
                ChipGroup(
                    options: EspressoType.allCases.map { ($0.displayName, $0) },
                    selection: $selectedEspresso
                )

                if selectedEspresso != nil {
                    HStack(spacing: 12) {
                        Text("浓缩份数")
                            .font(.sbBodyS)
                            .foregroundStyle(Color.sbInk2)
                        Stepper(
                            value: Binding(
                                get: { espressoShots ?? 1 },
                                set: { espressoShots = $0 }
                            ),
                            in: 1...5,
                            label: { Text("\(espressoShots ?? 1) 份") }
                        )
                        .font(.sbBodyS)
                    }
                }
            }
        }
    }

    private var foamSection: some View {
        formSection("奶泡") {
            ChipGroup(
                options: FoamLevel.allCases.map { ($0.displayName, $0) },
                selection: $selectedFoam
            )
        }
    }

    private var flavorSyrupSection: some View {
        formSection("无糖风味定制/添加") {
            VStack(spacing: 8) {
                if selectedFlavorSyrups.isEmpty {
                    Text("未选择")
                        .font(.sbBodyS)
                        .foregroundStyle(Color.sbInk3)
                } else {
                    ForEach(selectedFlavorSyrups, id: \.self) { flavor in
                        HStack {
                            Text(flavor.displayName)
                                .font(.sbBodyS)
                                .foregroundStyle(Color.sbInk)
                            Spacer()
                            Button {
                                selectedFlavorSyrups.removeAll { $0 == flavor }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.sbInk3)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.sbGreenTint)
                        .cornerRadius(10)
                    }
                }

                Menu {
                    ForEach(FlavorSyrup.allCases, id: \.self) { flavor in
                        Button {
                            if !selectedFlavorSyrups.contains(flavor) {
                                selectedFlavorSyrups.append(flavor)
                            }
                        } label: {
                            HStack {
                                Text(flavor.displayName)
                                if selectedFlavorSyrups.contains(flavor) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("添加风味")
                    }
                    .font(.sbBodyS)
                    .foregroundStyle(Color.sbGreenDeep)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.sbGreenPale)
                    .cornerRadius(10)
                }
            }
        }
    }

    private var sweetSection: some View {
        formSection("甜度选择") {
            VStack(spacing: 12) {
                ChipGroup(
                    options: SweetOption.allCases.map { ($0.displayName, $0) },
                    selection: $selectedSweetOption
                )

                if selectedSweetOption != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("位置")
                            .font(.sbBodyS)
                            .foregroundStyle(Color.sbInk2)
                        ChipGroup(
                            options: SweetPosition.allCases.map { ($0.displayName, $0) },
                            selection: $selectedSweetPosition
                        )
                    }
                }
            }
        }
    }

    private var whippedCreamSection: some View {
        formSection("鲜奶油") {
            ChipGroup(
                options: WhippedCreamLevel.allCases.map { ($0.displayName, $0) },
                selection: $selectedWhippedCream
            )
        }
    }

    private var priceSection: some View {
        formSection("价格") {
            HStack(spacing: 12) {
                Text("¥")
                    .font(.sbBodyM)
                    .foregroundStyle(Color.sbInk2)
                TextField("自定义价格", text: $customPrice)
                    .font(.sbBodyM)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.sbPaper2)
                    .cornerRadius(8)

                if customPrice.isEmpty {
                    Text("默认：¥\(computedPrice)")
                        .font(.sbCaption)
                        .foregroundStyle(Color.sbInk3)
                }
            }
        }
    }

    private var shotSection: some View {
        formSection("浓缩 Shot") {
            HStack(spacing: 16) {
                Button {
                    if shotCount > 1 { shotCount -= 1 }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(Color.sbLine)
                        .cornerRadius(10)
                }

                Text("×\(shotCount + extraShots)")
                    .font(.sbNumDisplay)
                    .foregroundStyle(Color.sbInk)
                    .monospacedDigit()
                    .frame(minWidth: 44)

                Button { shotCount += 1 } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(Color.sbLine)
                        .cornerRadius(10)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 4) {
                        Button {
                            if extraShots > 0 { extraShots -= 1 }
                        } label: { Image(systemName: "minus.circle").foregroundStyle(Color.sbInk3) }
                        Text("+\(extraShots) shot")
                            .font(.sbCaption)
                            .foregroundStyle(Color.sbGreenDeep)
                        Button { extraShots += 1 } label: { Image(systemName: "plus.circle").foregroundStyle(Color.sbGreenDeep) }
                    }
                    if extraShots > 0 {
                        Text("额外 +¥\(extraShots * 4)")
                            .font(.sbLabel)
                            .foregroundStyle(Color.sbAmber)
                    }
                }
            }
        }
    }

    private var milkSection: some View {
        formSection("牛奶") {
            ChipGroup(
                options: MilkType.allCases.map { ($0.rawValue, $0) },
                selection: $selectedMilk
            )
        }
    }

    private var legacyFlavorSection: some View {
        formSection("风味添加") {
            VStack(spacing: 8) {
                ForEach(selectedFlavors, id: \.name) { f in
                    HStack {
                        Text(f.name)
                            .font(.sbBodyS)
                            .foregroundStyle(Color.sbInk)
                        if f.extraPrice > 0 {
                            Text("+¥\(f.extraPrice)")
                                .font(.sbLabel)
                                .foregroundStyle(Color.sbAmber)
                        }
                        Spacer()
                        Button {
                            selectedFlavors.removeAll { $0.name == f.name }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.sbInk3)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.sbGreenTint)
                    .cornerRadius(10)
                }

                Button { showFlavorPicker = true } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("添加风味")
                    }
                    .font(.sbBodyS)
                    .foregroundStyle(Color.sbGreenDeep)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.sbGreenPale)
                    .cornerRadius(10)
                }
            }
        }
    }

    private var ratingSection: some View {
        formSection("今日感受") {
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Button { rating = star } label: {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 26))
                            .foregroundStyle(star <= rating ? Color.sbAmber : Color.sbLine2)
                    }
                }
                Spacer()
            }
        }
    }

    private var noteSection: some View {
        formSection("备注") {
            ZStack(alignment: .topLeading) {
                if note.isEmpty {
                    Text("写点什么…(地点 / 心情 / 配什么吃的)")
                        .font(.sbBodyS)
                        .foregroundStyle(Color.sbInk3)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                }
                TextEditor(text: $note)
                    .font(.sbBodyS)
                    .foregroundStyle(Color.sbInk)
                    .frame(minHeight: 80)
                    .scrollContentBackground(.hidden)
            }
            .padding(10)
            .background(Color.sbPaper2)
            .cornerRadius(12)
        }
    }

    private var priceCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("本杯花费")
                    .font(.sbLabel)
                    .foregroundStyle(Color.sbInk2)
                Text("¥\(computedPrice)")
                    .font(.sbNumDisplay)
                    .foregroundStyle(Color.sbGreenDeep)
                    .monospacedDigit()
                    .animation(.easeOut(duration: 0.2), value: computedPrice)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("本月累计")
                    .font(.sbLabel)
                    .foregroundStyle(Color.sbInk2)
                Text("¥\(monthlyTotal + computedPrice)")
                    .font(.system(size: 18, weight: .heavy, design: .monospaced))
                    .foregroundStyle(Color.sbInk1)
                    .monospacedDigit()
            }
        }
        .padding(16)
        .background(Color.sbGreenPale)
        .cornerRadius(16)
    }

    // MARK: Bottom bar
    private var bottomBar: some View {
        HStack(spacing: 12) {
            GhostButton(title: "放弃") { showDiscardAlert = true }
                .frame(width: 100)
            PrimaryButton(title: "保存这一杯 ✓", action: save)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
    }

    // MARK: Flavor picker
    private var flavorPickerSheet: some View {
        NavigationStack {
            List(availableFlavors, id: \.name) { f in
                Button {
                    if !selectedFlavors.contains(where: { $0.name == f.name }) {
                        selectedFlavors.append(f)
                    }
                    showFlavorPicker = false
                } label: {
                    HStack {
                        Text(f.name).font(.sbBodyM).foregroundStyle(Color.sbInk)
                        Spacer()
                        if f.extraPrice > 0 {
                            Text("+¥\(f.extraPrice)").font(.sbCaption).foregroundStyle(Color.sbAmber)
                        }
                        if selectedFlavors.contains(where: { $0.name == f.name }) {
                            Image(systemName: "checkmark").foregroundStyle(Color.sbGreenDeep)
                        }
                    }
                }
            }
            .navigationTitle("选择风味")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") { showFlavorPicker = false }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: Save
    private func save() {
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)

        let record = CupRecord(
            drinkID: drink.id,
            cupSize: selectedSize,
            temperature: selectedTemp,
            milkType: selectedMilk,
            espressoType: selectedEspresso,
            espressoShots: espressoShots,
            foamLevel: selectedFoam,
            sweetOption: selectedSweetOption,
            sweetPosition: selectedSweetPosition,
            whippedCreamLevel: selectedWhippedCream,
            flavorSyrups: selectedFlavorSyrups,
            sugarLevel: selectedSugar,
            shotCount: shotCount,
            extraShots: extraShots,
            flavors: selectedFlavors,
            customPrice: customPrice.isEmpty ? nil : Int(customPrice),
            rating: rating,
            note: note.isEmpty ? nil : note,
            computedPrice: computedPrice,
            isFirstTime: isFirstTime
        )
        context.insert(record)
        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save CupRecord: \(error)")
        }

        let drinkCount = allRecords.filter { $0.drinkID == drink.id }.count + 1
        let msg: String
        if isFirstTime {
            msg = "🎉 第一次喝 · 解锁 +1"
        } else {
            msg = "已记录这一杯 ✓ (第 \(drinkCount) 次)"
        }
        onSaved(msg)
    }

    // MARK: Helpers
    private func formSection<C: View>(_ title: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.sbBodyMB)
                .foregroundStyle(Color.sbInk)
            content()
        }
        .padding(14)
        .background(Color.sbPaper)
        .cornerRadius(16)
        .shadowSm()
    }

    private func label(_ text: String, fg: Color, bg: Color) -> some View {
        Text(text)
            .font(.sbLabel)
            .foregroundStyle(fg)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(bg)
            .cornerRadius(8)
    }
}

private extension Date {
    func formatted(_ format: String) -> String {
        let f = DateFormatter()
        f.dateFormat = format
        f.locale = Locale(identifier: "zh_CN")
        return f.string(from: self)
    }
}

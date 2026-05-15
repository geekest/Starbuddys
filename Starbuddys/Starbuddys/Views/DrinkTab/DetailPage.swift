import SwiftUI
import SwiftData

struct DetailPage: View {
    let drink: Drink
    var prefill: CupRecord?
    let allRecords: [CupRecord]
    var onSaved: (String) -> Void
    var onCancel: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var favorites = FavoritesStore.shared

    // Form state - Basic
    @State private var selectedSize: CupSize
    @State private var selectedTemp: Temperature
    @State private var selectedMilk: MilkType

    // Form state - Coffee specific
    @State private var selectedEspresso: EspressoType?
    @State private var selectedEspressoStrength: EspressoStrength?
    @State private var espressoShots: Int
    @State private var selectedFoam: FoamLevel?

    // Form state - Sweetness
    @State private var selectedSweetOption: SweetOption?
    @State private var selectedSweetPosition: SweetPosition?

    // Form state - Toppings
    @State private var selectedWhippedCream: WhippedCreamLevel?
    @State private var selectedFlavorSyrups: [FlavorSyrup] = []

    // Form state - User input
    @State private var customPrice: String = ""
    @State private var rating: Int
    @State private var note: String
    @State private var showDiscardAlert = false

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
        _selectedEspressoStrength = State(initialValue: prefill?.espressoStrength)
        _espressoShots = State(initialValue: prefill?.espressoShots ?? 2)
        _selectedFoam = State(initialValue: prefill?.foamLevel)

        _selectedSweetOption = State(initialValue: prefill?.sweetOption)
        _selectedSweetPosition = State(initialValue: prefill?.sweetPosition)

        _selectedWhippedCream = State(initialValue: prefill?.whippedCreamLevel)
        _selectedFlavorSyrups = State(initialValue: prefill?.flavorSyrups ?? [])

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
        let base = drink.sizePrices[selectedSize] ?? drink.sizePrices[drink.defaultSize] ?? 0
        let extraEspresso = max(0, espressoShots - 2) * 4
        return base + extraEspresso
    }

    private var sizeOptions: [(label: String, sub: String?, value: CupSize, disabled: Bool)] {
        CupSize.allCases.map { size in
            (label: size.displayName, sub: size.ml, value: size, disabled: false)
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
                        favorites.toggle(drink.id)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        let isFav = favorites.isFavorite(drink.id)
                        Image(systemName: isFav ? "heart.fill" : "heart")
                            .font(.system(size: 17))
                            .foregroundStyle(isFav ? Color.sbAmber : Color.sbInk1)
                            .frame(width: 36, height: 36)
                            .background(isFav ? Color.sbAmberSoft : Color.sbLine.opacity(0.5))
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
                Text(drink.nameEN.isEmpty ? drink.category.displayName : "\(drink.nameEN) · \(drink.category.displayName)")
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk2)

                HStack(spacing: 8) {
                    BrandBadge(brand: drink.brand)
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

    private var espressoSection: some View {
        formSection("浓缩咖啡") {
            VStack(alignment: .leading, spacing: 12) {
                ChipGroup(
                    options: EspressoType.allCases.map { ($0.displayName, $0) },
                    selection: $selectedEspresso
                )

                OptionCardGroup(
                    options: EspressoStrength.allCases.map {
                        (title: $0.displayName, subtitle: $0.subtitle, value: $0)
                    },
                    selection: $selectedEspressoStrength
                )

                HStack(spacing: 12) {
                    Text("浓缩份数")
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk1)
                    Spacer()
                    Button {
                        if espressoShots > 1 { espressoShots -= 1 }
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 22))
                            .foregroundStyle(espressoShots > 1 ? Color.sbGreenDeep : Color.sbInk3)
                    }
                    Text("\(espressoShots) 份")
                        .font(.sbBodyMB)
                        .monospacedDigit()
                        .frame(minWidth: 56)
                        .multilineTextAlignment(.center)
                    Button {
                        if espressoShots < 4 { espressoShots += 1 }
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 22))
                            .foregroundStyle(espressoShots < 4 ? Color.sbGreenDeep : Color.sbInk3)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.sbGreenPale)
                .cornerRadius(10)
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
        formSection("无糖风味定制（可多选）") {
            MultiSelectChipGroup(
                options: FlavorSyrup.allCases.map { ($0.displayName, $0) },
                selection: $selectedFlavorSyrups
            )
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

    private var milkSection: some View {
        formSection("牛奶") {
            ChipGroup(
                options: MilkType.allCases.map { ($0.rawValue, $0) },
                selection: $selectedMilk
            )
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
            espressoStrength: selectedEspressoStrength,
            espressoShots: espressoShots,
            foamLevel: selectedFoam,
            sweetOption: selectedSweetOption,
            sweetPosition: selectedSweetPosition,
            whippedCreamLevel: selectedWhippedCream,
            flavorSyrups: selectedFlavorSyrups,
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

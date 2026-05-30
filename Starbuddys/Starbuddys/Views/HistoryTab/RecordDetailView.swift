import SwiftUI
import SwiftData

struct RecordDetailView: View {
    @Bindable var record: CupRecord
    @EnvironmentObject private var repo: DrinkRepository
    @Query(sort: \CupRecord.drunkAt, order: .reverse) private var allRecords: [CupRecord]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var showEdit = false

    private var drink: Drink? { repo.drink(id: record.drinkID) }

    var body: some View {
        ZStack {
            Color.sbCanvas.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 60)
                    if let drink {
                        heroSection(drink: drink)
                    }
                    VStack(spacing: 12) {
                        timeCard
                        if let drink { specCard(drink: drink) }
                        if hasCoffeeDetail { coffeeCard }
                        priceCard
                        ratingCard
                        if let note = record.note, !note.isEmpty { noteCard(note: note) }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarHidden(true)
        .overlay(alignment: .top) {
            NavHeaderView(
                title: "记录详情",
                leftAction: { dismiss() },
                rightContent: AnyView(
                    Button("编辑") { showEdit = true }
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbGreenDeep)
                        .frame(width: 44, height: 36)
                )
            )
            .background(Color.sbCanvas.opacity(0.95))
        }
        .sheet(isPresented: $showEdit) {
            if let drink {
                NavigationStack {
                    DetailPage(
                        drink: drink,
                        prefill: record,
                        existingRecord: record,
                        allRecords: allRecords,
                        onSaved: { _ in showEdit = false },
                        onCancel: { showEdit = false }
                    )
                }
            }
        }
    }

    private func heroSection(drink: Drink) -> some View {
        VStack(spacing: 12) {
            DrinkAvatar(drink: drink, size: 120)
                .shadowMd()
            VStack(spacing: 4) {
                Text(drink.nameCN)
                    .font(.sbTitleL)
                    .foregroundStyle(Color.sbInk)
                    .multilineTextAlignment(.center)
                Text(drink.nameEN.isEmpty ? drink.category.displayName : "\(drink.nameEN) · \(drink.category.displayName)")
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk2)
                BrandBadge(brand: drink.brand)
                    .padding(.top, 4)
            }
        }
        .padding(.bottom, 20)
    }

    private var timeCard: some View {
        DCard {
            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.sbInk2)
                Text("饮用时间")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                Spacer()
                Text(record.drunkAt.formatted(date: .long, time: .shortened))
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk2)
            }
        }
    }

    private func specCard(drink: Drink) -> some View {
        DCard {
            VStack(alignment: .leading, spacing: 8) {
                Label("规格", systemImage: "cup.and.saucer")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                Divider()
                HStack {
                    specRow("杯型", value: record.cupSize.displayName)
                    Spacer()
                    specRow("温度", value: record.temperature.rawValue)
                    Spacer()
                    specRow("奶类", value: record.milkType.rawValue)
                }
            }
        }
    }

    private var hasCoffeeDetail: Bool {
        record.espressoType != nil || record.foamLevel != nil || record.sweetOption != nil
    }

    private var coffeeCard: some View {
        DCard {
            VStack(alignment: .leading, spacing: 8) {
                Label("咖啡定制", systemImage: "sparkles")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    if let v = record.espressoType { detailRow("浓缩", value: v.displayName) }
                    if let v = record.espressoStrength { detailRow("萃取", value: v.displayName) }
                    if let v = record.espressoShots { detailRow("份数", value: "\(v) 份") }
                    if let v = record.foamLevel { detailRow("奶泡", value: v.displayName) }
                    if let v = record.sweetOption { detailRow("甜度", value: v.displayName) }
                    if let v = record.sweetPosition { detailRow("甜位", value: v.displayName) }
                    if let v = record.whippedCreamLevel { detailRow("鲜奶油", value: v.displayName) }
                    let syrups = record.flavorSyrups
                    if !syrups.isEmpty {
                        detailRow("风味", value: syrups.map(\.displayName).joined(separator: "、"))
                    }
                }
            }
        }
    }

    private var priceCard: some View {
        DCard {
            HStack {
                Image(systemName: "yensign.circle")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.sbInk2)
                Text("价格")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                Spacer()
                Text("¥\(record.computedPrice)")
                    .font(.system(size: 20, weight: .heavy, design: .monospaced))
                    .foregroundStyle(Color.sbGreenDeep)
            }
        }
    }

    private var ratingCard: some View {
        DCard {
            HStack {
                Image(systemName: "star")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.sbInk2)
                Text("评分")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                Spacer()
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { s in
                        Image(systemName: s <= record.rating ? "star.fill" : "star")
                            .font(.system(size: 18))
                            .foregroundStyle(s <= record.rating ? Color.sbAmber : Color.sbLine2)
                    }
                }
            }
        }
    }

    private func noteCard(note: String) -> some View {
        DCard {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "text.bubble")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.sbInk2)
                    Text("备注")
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk)
                    Spacer()
                }
                Text(note)
                    .font(.sbBodyS)
                    .foregroundStyle(Color.sbInk1)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func specRow(_ label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.sbCaption)
                .foregroundStyle(Color.sbInk3)
            Text(value)
                .font(.sbBodyMB)
                .foregroundStyle(Color.sbInk)
        }
    }

    private func detailRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.sbCaption)
                .foregroundStyle(Color.sbInk2)
                .frame(width: 44, alignment: .leading)
            Text(value)
                .font(.sbBodyS)
                .foregroundStyle(Color.sbInk)
        }
    }
}

#Preview("记录详情") {
    struct Wrapper: View {
        @Environment(\.modelContext) private var context
        @State private var record: CupRecord?

        var body: some View {
            Group {
                if let record {
                    RecordDetailView(record: record)
                        .environmentObject(DrinkRepository.shared)
                } else {
                    Color.sbCanvas.onAppear {
                        let r = CupRecord(
                            drinkID: "sb-001",
                            cupSize: .grande,
                            temperature: .hot,
                            milkType: .whole,
                            computedPrice: 40,
                            isFirstTime: true
                        )
                        context.insert(r)
                        record = r
                    }
                }
            }
        }
    }
    return Wrapper()
        .modelContainer(for: CupRecord.self, inMemory: true)
}

import SwiftUI
import SwiftData

enum DrinkTabState {
    case idle
    case result(Drink)
}

struct DrinkTabView: View {
    @EnvironmentObject private var repo: DrinkRepository
    @Environment(\.modelContext) private var context
    @Query(sort: \CupRecord.drunkAt, order: .reverse) private var records: [CupRecord]

    @State private var tabState: DrinkTabState = .idle
    @State private var showPicker = false
    @State private var detailDrink: Drink? = nil
    @State private var prefillRecord: CupRecord? = nil
    @State private var toast: String? = nil
    @State private var isBrewing = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sbCanvas.ignoresSafeArea()

                switch tabState {
                case .idle:
                    DrinkTabIdle(
                        records: records,
                        isBrewing: isBrewing,
                        onBrew: brewAction,
                        onPickerOpen: { showPicker = true },
                        onRepeat: { record in
                            if let drink = repo.drink(id: record.drinkID) {
                                prefillRecord = record
                                detailDrink = drink
                            }
                        }
                    )

                case .result(let drink):
                    DrinkTabResult(
                        drink: drink,
                        records: records,
                        onClose: { withAnimation(.spring()) { tabState = .idle } },
                        onRefresh: brewAction,
                        onRecord: {
                            detailDrink = drink
                            prefillRecord = nil
                        }
                    )
                }

                // Toast
                if let msg = toast {
                    VStack {
                        Spacer()
                        ToastView(message: msg)
                            .padding(.bottom, 100)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .navigationDestination(item: $detailDrink) { drink in
                DetailPage(
                    drink: drink,
                    prefill: prefillRecord,
                    allRecords: records,
                    onSaved: { msg in
                        detailDrink = nil
                        prefillRecord = nil
                        withAnimation(.spring()) { tabState = .idle }
                        showToast(msg)
                    },
                    onCancel: { detailDrink = nil; prefillRecord = nil }
                )
            }
            .sheet(isPresented: $showPicker) {
                DrinkPickerSheet(records: records) { drink in
                    showPicker = false
                    detailDrink = drink
                    prefillRecord = nil
                }
            }
        }
        .onChange(of: toast) { _, new in
            guard new != nil else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation { toast = nil }
            }
        }
    }

    private func brewAction() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        isBrewing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isBrewing = false
            if let drink = BrewRecommender.recommend(from: repo.drinks, records: records) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    tabState = .result(drink)
                }
            }
        }
    }

    private func showToast(_ msg: String) {
        withAnimation { toast = msg }
    }
}

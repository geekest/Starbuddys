import SwiftUI

struct DrinkTabIdle: View {
    let records: [CupRecord]
    var isBrewing: Bool = false
    var onBrew: () -> Void
    var onPickerOpen: () -> Void
    var onRepeat: (CupRecord) -> Void

    @EnvironmentObject private var repo: DrinkRepository
    @State private var brewScale: CGFloat = 1.0

    private var greeting: (String, String) {
        let h = Calendar.current.component(.hour, from: Date())
        switch h {
        case 5..<11:  return ("早上好，Harvey", "今天喝什么?")
        case 11..<14: return ("午安，Harvey", "来杯解压的?")
        case 14..<18: return ("下午好，Harvey", "今天喝什么?")
        case 18..<23: return ("晚上好，Harvey", "再来一杯?")
        default:       return ("夜深了，Harvey", "还要再喝?")
        }
    }

    private var lastRecord: CupRecord? {
        let cutoff = Date().addingTimeInterval(-86400)
        return records.first { $0.drunkAt >= cutoff }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(greeting.0)
                            .font(.sbBodyM)
                            .foregroundStyle(Color.sbInk2)
                        Text(greeting.1)
                            .font(.sbTitleXL)
                            .foregroundStyle(Color.sbInk)
                    }
                    Spacer()
                    IconBtn(icon: "bell")
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                // Espresso machine
                ZStack(alignment: .bottom) {
                    EspressoMachineView(brewing: isBrewing)
                        .frame(height: 470)
                        .onTapGesture { handleBrewTap() }

                    // "BREW" hint text
                    HStack(spacing: 4) {
                        Text("点击")
                            .font(.sbBodyS)
                            .foregroundStyle(Color.sbInk2)
                        Text("BREW")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.sbGreenDeep)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.sbGreenPale)
                            .clipShape(Capsule())
                        Text("让今日运势随机出杯")
                            .font(.sbBodyS)
                            .foregroundStyle(Color.sbInk2)
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 8)
                .padding(.top, 4)

                // Last record card
                Group {
                    if let record = lastRecord, let drink = repo.drink(id: record.drinkID) {
                        lastBrewCard(record: record, drink: drink)
                    } else {
                        emptyCard
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Secondary CTA
                GhostButton(title: "我自己选 →", action: onPickerOpen)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
            }
        }
        .scrollIndicators(.hidden)
    }

    private func handleBrewTap() {
        withAnimation(.spring(response: 0.15, dampingFraction: 0.6)) { brewScale = 0.95 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { brewScale = 1.0 }
            onBrew()
        }
    }

    @ViewBuilder
    private func lastBrewCard(record: CupRecord, drink: Drink) -> some View {
        DCardBorder {
            HStack(spacing: 14) {
                DrinkAvatar(drink: drink, size: 56)

                VStack(alignment: .leading, spacing: 2) {
                    Text("上一杯 · \(record.drunkAt.formatted(.relative(presentation: .named)))")
                        .font(.sbLabel)
                        .foregroundStyle(Color.sbInk2)
                    Text(drink.nameCN)
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk)
                        .lineLimit(1)
                    Text(record.shortSpec + " · ¥\(record.computedPrice)")
                        .font(.sbCaption)
                        .foregroundStyle(Color.sbInk2)
                }

                Spacer()

                Button { onRepeat(record) } label: {
                    Text("再来一杯 →")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.sbGreenDeep)
                }
            }
        }
        .onTapGesture { onRepeat(record) }
    }

    @ViewBuilder
    private var emptyCard: some View {
        DCardBorder {
            HStack(spacing: 14) {
                Circle()
                    .fill(Color.sbGreenPale)
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: "cup.and.saucer")
                            .font(.system(size: 22))
                            .foregroundStyle(Color.sbGreenDeep.opacity(0.5))
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text("还没记过")
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk)
                    Text("按 BREW 开张 ☕")
                        .font(.sbCaption)
                        .foregroundStyle(Color.sbInk2)
                }
                Spacer()
            }
        }
    }
}

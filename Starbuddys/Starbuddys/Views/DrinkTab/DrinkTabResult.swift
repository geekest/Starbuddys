import SwiftUI

struct DrinkTabResult: View {
    let drink: Drink
    let records: [CupRecord]
    var onClose: () -> Void
    var onRefresh: () -> Void
    var onRecord: () -> Void

    @State private var dragOffset: CGFloat = 0
    @State private var cardVisible = true

    private var isFirstTime: Bool {
        !records.contains { $0.drinkID == drink.id }
    }

    private var fortuneText: String {
        let options = ["今日运势·上佳", "宇宙安排了这杯", "缘分注定", "这杯,你猜不到吧", "今日特调"]
        return options[abs(drink.id.hashValue) % options.count]
    }

    private var (recSize, recTemp, recSugar): (CupSize, Temperature, SugarLevel) {
        BrewRecommender.defaultConfig(for: drink)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Dimmed brewing machine
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(fortuneText)
                                .font(.sbBodyM)
                                .foregroundStyle(Color.sbInk2)
                            Text("来一杯…")
                                .font(.sbTitleXL)
                                .foregroundStyle(Color.sbInk)
                        }
                        Spacer()
                        IconBtn(icon: "bell")
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                    ZStack {
                        EspressoMachineView(brewing: true)
                            .frame(height: 470)
                            .opacity(0.6)
                            .blur(radius: 0.5)

                        Color.black.opacity(0.18)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .scrollDisabled(true)

            // Result card
            if cardVisible {
                recommendCard
                    .offset(y: max(0, dragOffset))
                    .gesture(
                        DragGesture()
                            .onChanged { v in dragOffset = v.translation.height }
                            .onEnded { v in
                                if v.translation.height > 80 {
                                    withAnimation(.spring()) { cardVisible = false }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { onClose() }
                                } else {
                                    withAnimation(.spring()) { dragOffset = 0 }
                                }
                            }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear { cardVisible = true; dragOffset = 0 }
    }

    private var recommendCard: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.sbLine2)
                .frame(width: 36, height: 4)
                .padding(.top, 10)
                .padding(.bottom, 16)

            // Drink info
            HStack(alignment: .top, spacing: 16) {
                DrinkAvatar(drink: drink, size: 92)

                VStack(alignment: .leading, spacing: 4) {
                    if isFirstTime {
                        Text("NEW · 第一次喝")
                            .font(.sbLabel)
                            .foregroundStyle(Color.sbAmber)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.sbAmberSoft)
                            .cornerRadius(6)
                    }
                    Text(drink.nameCN)
                        .font(.sbTitleM)
                        .foregroundStyle(Color.sbInk)
                        .lineLimit(2)
                    Text("\(drink.nameEN) · \(drink.category.displayName)")
                        .font(.sbCaption)
                        .foregroundStyle(Color.sbInk2)
                    Text(drink.description)
                        .font(.sbBodyS)
                        .foregroundStyle(Color.sbInk1)
                        .lineLimit(2)
                        .padding(.top, 2)
                }
            }
            .padding(.horizontal, 18)

            // Recommendation row
            HStack(spacing: 8) {
                ForEach([("推荐杯型", recSize.displayName),
                         ("推荐温度", recTemp.rawValue),
                         ("推荐糖度", recSugar.rawValue)], id: \.0) { label, value in
                    VStack(spacing: 3) {
                        Text(label)
                            .font(.sbLabel)
                            .foregroundStyle(Color.sbInk2)
                        Text(value)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.sbGreenDeep)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.sbGreenTint)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)

            // CTA row
            HStack(spacing: 10) {
                Button {
                    withAnimation(.easeOut(duration: 0.2)) { cardVisible = false }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        cardVisible = true
                        onRefresh()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.sbInk1)
                        .frame(width: 52, height: 52)
                        .background(Color.sbLine.opacity(0.6))
                        .cornerRadius(14)
                }

                PrimaryButton(title: "记一杯 →", action: onRecord)
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)

            Text("← 不想喝？点刷新重新扭 / 下拉关闭")
                .font(.sbLabel)
                .foregroundStyle(Color.sbInk3)
                .padding(.top, 10)
                .padding(.bottom, 24)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.sbPaper)
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(alignment: .top) {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.sbLine, lineWidth: 1)
        }
        .shadowLg()
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

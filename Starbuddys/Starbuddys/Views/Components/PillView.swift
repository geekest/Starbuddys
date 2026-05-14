import SwiftUI

enum PillStyle {
    case normal, active, soft
}

struct PillView: View {
    let title: String
    var style: PillStyle = .normal
    var badge: Int? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        Button { action?() } label: {
            HStack(spacing: 4) {
                Text(title)
                    .font(.sbBodyS)
                if let n = badge {
                    Text("\(n)")
                        .font(.sbLabel)
                        .foregroundStyle(labelColor.opacity(0.65))
                }
            }
            .foregroundStyle(labelColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(bgColor)
            .clipShape(Capsule())
            .overlay(
                Capsule().strokeBorder(borderColor, lineWidth: style == .active ? 1.5 : 0)
            )
        }
        .buttonStyle(.plain)
    }

    private var bgColor: Color {
        switch style {
        case .normal: return Color.sbLine.opacity(0.5)
        case .active: return Color.sbGreenDeep
        case .soft:   return Color.sbGreenPale
        }
    }

    private var labelColor: Color {
        switch style {
        case .normal: return Color.sbInk1
        case .active: return .white
        case .soft:   return Color.sbGreenDeep
        }
    }

    private var borderColor: Color {
        style == .active ? Color.sbGreenDeep : .clear
    }
}

struct BrandBadge: View {
    let brand: BrandType
    var size: CGFloat = 11

    var body: some View {
        Text(brand.displayName)
            .font(.system(size: size, weight: .bold))
            .foregroundStyle(textColor)
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(bgColor)
            .clipShape(Capsule())
    }

    private var bgColor: Color {
        switch brand {
        case .starbucks: return Color.sbGreenPale
        case .manner:    return Color(red: 0.16, green: 0.16, blue: 0.18)
        }
    }
    private var textColor: Color {
        switch brand {
        case .starbucks: return Color.sbGreenDeep
        case .manner:    return .white
        }
    }
}

struct PillRow<T: Hashable>: View {
    let options: [(label: String, value: T, count: Int?)]
    @Binding var selection: T

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(options, id: \.value) { opt in
                    PillView(
                        title: opt.label,
                        style: selection == opt.value ? .active : .normal,
                        badge: opt.count
                    ) { selection = opt.value }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
    }
}

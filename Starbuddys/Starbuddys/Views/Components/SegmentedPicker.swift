import SwiftUI

struct SBSegmentedPicker<T: Hashable>: View {
    let options: [(label: String, sub: String?, value: T, disabled: Bool)]
    @Binding var selection: T

    var body: some View {
        HStack(spacing: 6) {
            ForEach(options, id: \.value) { opt in
                Button {
                    guard !opt.disabled else { return }
                    selection = opt.value
                } label: {
                    VStack(spacing: 1) {
                        Text(opt.label)
                            .font(.sbBodyS)
                        if let sub = opt.sub {
                            Text(sub)
                                .font(.system(size: 9, weight: .medium))
                                .opacity(0.7)
                        }
                    }
                    .foregroundStyle(
                        opt.disabled ? Color.sbInk3 :
                        selection == opt.value ? Color.sbGreenDeep : Color.sbInk1
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                opt.disabled ? Color.sbLine.opacity(0.3) :
                                selection == opt.value ? Color.sbGreenPale : Color.sbCanvas
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(
                                        (!opt.disabled && selection == opt.value) ? Color.sbGreenDeep : Color.clear,
                                        lineWidth: 1.5
                                    )
                            )
                    )
                }
                .buttonStyle(.plain)
                .disabled(opt.disabled)
            }
        }
    }
}

struct ChipGroup<T: Hashable>: View {
    let options: [(label: String, value: T)]
    @Binding var selection: T
    var columns: Int = 3

    var body: some View {
        let gridItems = Array(repeating: GridItem(.flexible(), spacing: 8), count: columns)
        LazyVGrid(columns: gridItems, spacing: 8) {
            ForEach(options, id: \.value) { opt in
                let isSelected = selection == opt.value
                Button { selection = opt.value } label: {
                    Text(opt.label)
                        .font(.sbBodyS)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(isSelected ? Color.sbGreenDeep : Color.sbInk1)
                        .frame(maxWidth: .infinity, minHeight: 20)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isSelected ? Color.sbGreenPale : Color.sbCanvas)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(
                                            isSelected ? Color.sbGreenDeep : Color.sbLine,
                                            lineWidth: 1.5
                                        )
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct MultiSelectChipGroup<T: Hashable>: View {
    let options: [(label: String, value: T)]
    @Binding var selection: [T]
    var columns: Int = 3

    var body: some View {
        let gridItems = Array(repeating: GridItem(.flexible(), spacing: 8), count: columns)
        LazyVGrid(columns: gridItems, spacing: 8) {
            ForEach(options, id: \.value) { opt in
                let isSelected = selection.contains(opt.value)
                Button {
                    if isSelected {
                        selection.removeAll { $0 == opt.value }
                    } else {
                        selection.append(opt.value)
                    }
                } label: {
                    Text(opt.label)
                        .font(.sbBodyS)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(isSelected ? Color.sbGreenDeep : Color.sbInk1)
                        .frame(maxWidth: .infinity, minHeight: 20)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isSelected ? Color.sbGreenPale : Color.sbCanvas)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(
                                            isSelected ? Color.sbGreenDeep : Color.sbLine,
                                            lineWidth: 1.5
                                        )
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct OptionCardGroup<T: Hashable>: View {
    let options: [(title: String, subtitle: String, value: T)]
    @Binding var selection: T?
    var columns: Int = 3

    var body: some View {
        let gridItems = Array(repeating: GridItem(.flexible(), spacing: 8), count: columns)
        LazyVGrid(columns: gridItems, spacing: 8) {
            ForEach(options, id: \.value) { opt in
                let isSelected = selection == opt.value
                Button { selection = opt.value } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(isSelected ? Color.sbGreenDeep : Color.sbInk2)
                        Text(opt.title)
                            .font(.sbBodyMB)
                            .foregroundStyle(isSelected ? Color.sbGreenDeep : Color.sbInk1)
                        Text(opt.subtitle)
                            .font(.sbLabel)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.sbInk3)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color.sbGreenPale : Color.sbCanvas)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(
                                        isSelected ? Color.sbGreenDeep : Color.sbLine,
                                        lineWidth: 1.5
                                    )
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        layout(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (i, frame) in result.frames.enumerated() {
            subviews[i].place(
                at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                proposal: ProposedViewSize(frame.size)
            )
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let containerWidth = proposal.width ?? 300
        var frames: [CGRect] = []
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0, maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > containerWidth && x > 0 {
                x = 0; y += rowHeight + spacing; rowHeight = 0
            }
            frames.append(CGRect(origin: .init(x: x, y: y), size: size))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }
        return (CGSize(width: maxX, height: y + rowHeight), frames)
    }
}

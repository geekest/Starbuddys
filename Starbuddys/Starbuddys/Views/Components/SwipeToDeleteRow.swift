import SwiftUI

struct SwipeToDeleteRow<Content: View>: View {
    let content: Content
    let onDelete: () -> Void
    var onTap: (() -> Void)? = nil

    init(
        onDelete: @escaping () -> Void,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.onDelete = onDelete
        self.onTap = onTap
        self.content = content()
    }

    @State private var offset: CGFloat = 0
    private let deleteWidth: CGFloat = 72

    var body: some View {
        ZStack(alignment: .trailing) {
            Button {
                onDelete()
                withAnimation(.spring()) { offset = 0 }
            } label: {
                Image(systemName: "trash.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: deleteWidth)
                    .frame(maxHeight: .infinity)
                    .background(Color.red)
            }
            .opacity(offset < -deleteWidth / 3 ? 1 : 0)

            content
                .offset(x: offset)
                .background(Color.sbPaper)
                .contentShape(Rectangle())
                .onTapGesture {
                    if offset < 0 {
                        withAnimation(.spring()) { offset = 0 }
                    } else {
                        onTap?()
                    }
                }
                .highPriorityGesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged { v in
                            if v.translation.width > 0, offset < 0 {
                                withAnimation(.spring()) { offset = 0 }
                                return
                            }
                            guard v.translation.width < 0 else { return }
                            offset = max(v.translation.width, -deleteWidth)
                        }
                        .onEnded { v in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                offset = v.translation.width < -deleteWidth / 2 ? -deleteWidth : 0
                            }
                        }
                )
        }
        .clipped()
    }
}

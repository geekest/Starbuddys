import SwiftUI

struct NavHeaderView: View {
    var title: String
    var leftAction: (() -> Void)? = nil
    var leftLabel: String = "chevron.left"
    var rightContent: AnyView? = nil

    var body: some View {
        HStack(spacing: 0) {
            // Left
            if let action = leftAction {
                Button(action: action) {
                    Image(systemName: leftLabel)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.sbInk)
                        .frame(width: 36, height: 36)
                        .background(Color.sbLine.opacity(0.5))
                        .cornerRadius(12)
                }
            } else {
                Spacer().frame(width: 36)
            }

            Spacer()

            Text(title)
                .font(.sbTitleS)
                .foregroundStyle(Color.sbInk)

            Spacer()

            // Right
            if let right = rightContent {
                right.frame(width: 36, height: 36)
            } else {
                Spacer().frame(width: 36)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

// Ghost button
struct GhostButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.sbBodyL)
                .foregroundStyle(Color.sbInk1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.sbLine.opacity(0.5))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.sbLine2, lineWidth: 1))
        }
    }
}

// Primary button
struct PrimaryButton: View {
    let title: String
    var disabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.sbBodyL)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(disabled ? Color.sbInk3 : Color.sbGreenDeep)
                .cornerRadius(14)
                .shadowButton()
        }
        .disabled(disabled)
    }
}

// Icon button (36×36)
struct IconBtn: View {
    let icon: String
    var action: (() -> Void)? = nil

    var body: some View {
        Button { action?() } label: {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.sbInk1)
                .frame(width: 36, height: 36)
                .background(Color.sbLine.opacity(0.5))
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// Toast overlay
struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.sbBodyS)
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.sbInk.opacity(0.88))
            .cornerRadius(100)
            .shadowMd()
    }
}

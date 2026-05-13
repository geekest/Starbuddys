import SwiftUI

struct DCard<Content: View>: View {
    var padding: CGFloat = 14
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(padding)
            .background(Color.sbPaper)
            .cornerRadius(16)
            .shadowSm()
    }
}

struct DCardBorder<Content: View>: View {
    var padding: CGFloat = 14
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(padding)
            .background(Color.sbPaper)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.sbLine, lineWidth: 1))
            .shadowSm()
    }
}

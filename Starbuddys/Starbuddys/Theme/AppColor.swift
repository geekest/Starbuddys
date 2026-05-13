import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 255, 255, 255)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }

    // Brand primary
    static let sbGreenDeep  = Color(hex: "#0E4A2E")
    static let sbGreen      = Color(hex: "#1F6B47")
    static let sbGreenPale  = Color(hex: "#E9F2EC")
    static let sbGreenTint  = Color(hex: "#F4F9F5")

    // Neutral
    static let sbCream      = Color(hex: "#FAF7F0")
    static let sbPaper      = Color(hex: "#FFFFFF")
    static let sbPaper2     = Color(hex: "#FAF9F5")
    static let sbCanvas     = Color(hex: "#F0EEE9")

    // Ink
    static let sbInk        = Color(hex: "#161614")
    static let sbInk1       = Color(hex: "#3D3D38")
    static let sbInk2       = Color(hex: "#6E6E68")
    static let sbInk3       = Color(hex: "#9E9E96")

    // Lines
    static let sbLine       = Color(hex: "#E8E5DC")
    static let sbLine2      = Color(hex: "#D5D2C8")

    // Accent
    static let sbAmber      = Color(hex: "#C08A3A")
    static let sbAmberSoft  = Color(hex: "#F6EDD7")
    static let sbRose       = Color(hex: "#C26C7E")
    static let sbRoseSoft   = Color(hex: "#F4E2E6")
    static let sbBerry      = Color(hex: "#884E5E")
    static let sbMatcha     = Color(hex: "#6B9168")
}

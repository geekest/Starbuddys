import SwiftUI

struct AppShadow {
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    let opacity: Double

    static let sm     = AppShadow(radius: 3,  x: 0, y: 1,  opacity: 0.06)
    static let md     = AppShadow(radius: 16, x: 0, y: 4,  opacity: 0.07)
    static let lg     = AppShadow(radius: 36, x: 0, y: 12, opacity: 0.10)
    static let button = AppShadow(radius: 20, x: 0, y: 8,  opacity: 0.25)
}

extension View {
    func shadowSm() -> some View {
        shadow(color: .black.opacity(AppShadow.sm.opacity), radius: AppShadow.sm.radius, x: AppShadow.sm.x, y: AppShadow.sm.y)
    }
    func shadowMd() -> some View {
        shadow(color: .black.opacity(AppShadow.md.opacity), radius: AppShadow.md.radius, x: AppShadow.md.x, y: AppShadow.md.y)
    }
    func shadowLg() -> some View {
        shadow(color: .black.opacity(AppShadow.lg.opacity), radius: AppShadow.lg.radius, x: AppShadow.lg.x, y: AppShadow.lg.y)
    }
    func shadowButton() -> some View {
        shadow(color: Color.sbGreenDeep.opacity(AppShadow.button.opacity), radius: AppShadow.button.radius, x: AppShadow.button.x, y: AppShadow.button.y)
    }
}

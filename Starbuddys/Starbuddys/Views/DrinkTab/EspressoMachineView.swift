import SwiftUI

// SwiftUI reimplementation of the mid/drink-tab.jsx EspressoMachine SVG
// ViewBox: 320×480, scaled to fill parent
struct EspressoMachineView: View {
    var brewing: Bool = false
    @State private var streamPhase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let scaleX = geo.size.width  / 320
            let scaleY = geo.size.height / 480

            Canvas { ctx, size in
                let sx = size.width  / 320
                let sy = size.height / 480

                func sc(_ x: CGFloat, _ y: CGFloat) -> CGPoint { .init(x: x * sx, y: y * sy) }
                func sw(_ w: CGFloat) -> CGFloat { w * sx }
                func sh(_ h: CGFloat) -> CGFloat { h * sy }

                // Floor shadow
                let shadowEllipse = Path(ellipseIn: CGRect(x: 20 * sx, y: 438 * sy, width: 280 * sx, height: 20 * sy))
                ctx.fill(shadowEllipse, with: .color(.black.opacity(0.10)))

                // HOPPER
                var hopper = Path()
                hopper.move(to: sc(80, 20))
                hopper.addQuadCurve(to: sc(92, 8), control: sc(80, 8))
                hopper.addLine(to: sc(228, 8))
                hopper.addQuadCurve(to: sc(240, 20), control: sc(240, 8))
                hopper.addLine(to: sc(240, 60))
                hopper.addLine(to: sc(80, 60))
                hopper.closeSubpath()
                ctx.fill(hopper, with: .color(Color(hex: "#2A1B12")))

                // Hopper top strip
                var hopperTop = Path()
                hopperTop.move(to: sc(80, 20))
                hopperTop.addQuadCurve(to: sc(92, 8), control: sc(80, 8))
                hopperTop.addLine(to: sc(228, 8))
                hopperTop.addQuadCurve(to: sc(240, 20), control: sc(240, 8))
                hopperTop.addLine(to: sc(240, 22))
                hopperTop.addLine(to: sc(80, 22))
                hopperTop.closeSubpath()
                ctx.fill(hopperTop, with: .color(Color(hex: "#3D2A1E")))

                // Hopper glass
                let glass = CGRect(x: 100 * sx, y: 22 * sy, width: 120 * sx, height: 32 * sy)
                ctx.fill(Path(roundedRect: glass, cornerRadius: sw(4)), with: .color(.white.opacity(0.18)))

                // MAIN BODY - green gradient approximated by left-darker/center-lighter blend
                let bodyRect = CGRect(x: 40 * sx, y: 60 * sy, width: 240 * sx, height: 252 * sy)
                var bodyPath = Path()
                bodyPath.move(to: sc(40, 60))
                bodyPath.addLine(to: sc(280, 60))
                bodyPath.addLine(to: sc(280, 312))
                bodyPath.addQuadCurve(to: sc(274, 318), control: sc(280, 318))
                bodyPath.addLine(to: sc(46, 318))
                bodyPath.addQuadCurve(to: sc(40, 312), control: sc(40, 318))
                bodyPath.closeSubpath()

                ctx.drawLayer { layerCtx in
                    let gradient = Gradient(colors: [Color(hex: "#0E4A2E"), Color(hex: "#1F6B47"), Color(hex: "#1F6B47"), Color(hex: "#0A3A23")])
                    layerCtx.fill(bodyPath, with: .linearGradient(
                        gradient,
                        startPoint: CGPoint(x: bodyRect.minX, y: bodyRect.midY),
                        endPoint: CGPoint(x: bodyRect.maxX, y: bodyRect.midY)
                    ))
                }

                // INNER PANEL
                let panelRect = CGRect(x: 56 * sx, y: 76 * sy, width: 208 * sx, height: 222 * sy)
                ctx.fill(Path(roundedRect: panelRect, cornerRadius: sw(12)), with: .color(Color(hex: "#FAF7F0")))

                // DISPLAY
                let displayRect = CGRect(x: 76 * sx, y: 92 * sy, width: 168 * sx, height: 52 * sy)
                ctx.fill(Path(roundedRect: displayRect, cornerRadius: sw(8)), with: .color(Color(hex: "#0E1815")))

                // GROUP HEAD
                let groupRect = CGRect(x: 120 * sx, y: 252 * sy, width: 80 * sx, height: 22 * sy)
                ctx.fill(Path(roundedRect: groupRect, cornerRadius: sw(4)),
                         with: .linearGradient(Gradient(colors: [Color(hex: "#D4CFC2"), Color(hex: "#807B70")]),
                                                startPoint: sc(120, 252), endPoint: sc(120, 274)))

                // PORTAFILTER
                let portaRect = CGRect(x: 134 * sx, y: 272 * sy, width: 52 * sx, height: 14 * sy)
                ctx.fill(Path(roundedRect: portaRect, cornerRadius: sw(2)),
                         with: .linearGradient(Gradient(colors: [Color(hex: "#D4CFC2"), Color(hex: "#807B70")]),
                                                startPoint: sc(134, 272), endPoint: sc(134, 286)))

                // WOOD HANDLE
                let woodRect = CGRect(x: 186 * sx, y: 274 * sy, width: 76 * sx, height: 14 * sy)
                ctx.fill(Path(roundedRect: woodRect, cornerRadius: sw(4)),
                         with: .linearGradient(Gradient(colors: [Color(hex: "#8E5728"), Color(hex: "#5C3618")]),
                                                startPoint: sc(186, 274), endPoint: sc(186, 288)))

                // DRIP TRAY
                let trayRect = CGRect(x: 40 * sx, y: 312 * sy, width: 240 * sx, height: 22 * sy)
                ctx.fill(Path(roundedRect: trayRect, cornerRadius: sw(4)), with: .color(Color(hex: "#1A1A18")))

                // SPOUTS
                ctx.fill(Path(roundedRect: CGRect(x: 146*sx, y:286*sy, width:4*sx, height:7*sy), cornerRadius: sw(1)),
                         with: .color(Color(hex: "#3D3D38")))
                ctx.fill(Path(roundedRect: CGRect(x: 166*sx, y:286*sy, width:4*sx, height:7*sy), cornerRadius: sw(1)),
                         with: .color(Color(hex: "#3D3D38")))

                // CUP (translate 126, 340 in SVG)
                let cx: CGFloat = 126, cy: CGFloat = 340
                // cup shadow
                let cupShadow = Path(ellipseIn: CGRect(x:(cx-10)*sx, y:(cy+59)*sy, width:88*sx, height:10*sy))
                ctx.fill(cupShadow, with: .color(.black.opacity(0.10)))
                // saucer
                let saucer = Path(ellipseIn: CGRect(x:(cx-10)*sx, y:(cy+57)*sy, width:88*sx, height:10*sy))
                ctx.fill(saucer, with: .color(Color(hex: "#F5F2EA")))
                // cup body
                var cupBody = Path()
                cupBody.move(to: CGPoint(x:(cx+8)*sx, y:(cy+18)*sy))
                cupBody.addQuadCurve(to: CGPoint(x:(cx+12)*sx, y:(cy+14)*sy), control: CGPoint(x:(cx+8)*sx, y:(cy+14)*sy))
                cupBody.addLine(to: CGPoint(x:(cx+56)*sx, y:(cy+14)*sy))
                cupBody.addQuadCurve(to: CGPoint(x:(cx+60)*sx, y:(cy+18)*sy), control: CGPoint(x:(cx+60)*sx, y:(cy+14)*sy))
                cupBody.addLine(to: CGPoint(x:(cx+60)*sx, y:(cy+52)*sy))
                cupBody.addQuadCurve(to: CGPoint(x:(cx+54)*sx, y:(cy+58)*sy), control: CGPoint(x:(cx+60)*sx, y:(cy+58)*sy))
                cupBody.addLine(to: CGPoint(x:(cx+14)*sx, y:(cy+58)*sy))
                cupBody.addQuadCurve(to: CGPoint(x:(cx+8)*sx, y:(cy+52)*sy), control: CGPoint(x:(cx+8)*sx, y:(cy+58)*sy))
                cupBody.closeSubpath()
                ctx.fill(cupBody, with: .color(Color(hex: "#F5F2EA")))
                // rim
                let rim = Path(ellipseIn: CGRect(x:(cx+8)*sx, y:(cy+13.5)*sy, width:52*sx, height:9*sy))
                ctx.fill(rim, with: .color(Color(hex: "#E5E0D5")))
                // liquid
                let liquid = Path(ellipseIn: CGRect(x:(cx+10)*sx, y:(cy+14.4)*sy, width:48*sx, height:7.2*sy))
                ctx.fill(liquid, with: .color(Color(hex: "#3A2615")))
                // highlight
                let highlight = Path(ellipseIn: CGRect(x:(cx+12.5)*sx, y:(cy+24)*sy, width:3*sx, height:20*sy))
                ctx.fill(highlight, with: .color(.white.opacity(0.6)))
            }
            .overlay {
                // Text overlay (Canvas doesn't render Text well cross-platform, use SwiftUI overlay)
                ZStack {
                    // BREW button
                    RoundedRectangle(cornerRadius: 14 * scaleX)
                        .fill(Color.sbGreenDeep)
                        .overlay(alignment: .top) {
                            RoundedRectangle(cornerRadius: 14 * scaleX)
                                .fill(Color.sbGreen)
                                .frame(height: 6 * scaleY)
                        }
                        .frame(width: 72 * scaleX, height: 50 * scaleY)
                        .overlay {
                            if !brewing {
                                Circle()
                                    .fill(RadialGradient(
                                        colors: [.white.opacity(0.5), .clear],
                                        center: .center, startRadius: 0, endRadius: 38 * scaleX))
                                    .frame(width: 76 * scaleX, height: 76 * scaleY)
                            }
                        }
                        .overlay {
                            Text("BREW")
                                .font(.system(size: 14 * scaleX, weight: .heavy, design: .monospaced))
                                .foregroundStyle(.white)
                                .tracking(2)
                        }
                        .position(x: 160 * scaleX, y: 180 * scaleY)

                    // Display text
                    VStack(spacing: 4) {
                        Text(brewing ? "EXTRACTING…" : "READY · 第 0 杯")
                            .font(.system(size: 9 * scaleX, weight: .medium, design: .monospaced))
                            .foregroundStyle(Color(hex: "#7FD8A6"))
                            .tracking(2)
                        Text(brewing ? "17.4s ▮▮▮▮▯" : "今日 · 0 杯")
                            .font(.system(size: 14 * scaleX, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color(hex: "#E9F2EC"))
                            .tracking(1)
                    }
                    .position(x: 160 * scaleX, y: 118 * scaleY)

                    // Brand mark
                    Text("STARBUDDYS")
                        .font(.system(size: 9 * scaleX, weight: .bold))
                        .foregroundStyle(Color.sbGreenDeep)
                        .tracking(4)
                        .position(x: 160 * scaleX, y: 232 * scaleY)

                    // Left knob label
                    Text("STEAM")
                        .font(.system(size: 7 * scaleX, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color.sbInk2)
                        .position(x: 92 * scaleX, y: 200 * scaleY)

                    // Right knob label
                    Text("WATER")
                        .font(.system(size: 7 * scaleX, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color.sbInk2)
                        .position(x: 228 * scaleX, y: 200 * scaleY)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            // Knobs as SwiftUI circles
            .overlay {
                ZStack {
                    // Left knob
                    Circle()
                        .fill(LinearGradient(colors: [Color(hex: "#A8A39A"), Color(hex: "#ECE7DC"), Color(hex: "#807B70")],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: 26 * scaleX, height: 26 * scaleX)
                        .overlay {
                            Circle().fill(Color(hex: "#1A1A18")).frame(width: 18 * scaleX, height: 18 * scaleX)
                            RoundedRectangle(cornerRadius: 1)
                                .fill(.white)
                                .frame(width: 2 * scaleX, height: 9 * scaleY)
                                .offset(y: -4 * scaleY)
                        }
                        .position(x: 92 * scaleX, y: 174 * scaleY)

                    // Right knob
                    Circle()
                        .fill(LinearGradient(colors: [Color(hex: "#A8A39A"), Color(hex: "#ECE7DC"), Color(hex: "#807B70")],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: 26 * scaleX, height: 26 * scaleX)
                        .overlay {
                            Circle().fill(Color(hex: "#1A1A18")).frame(width: 18 * scaleX, height: 18 * scaleX)
                            RoundedRectangle(cornerRadius: 1)
                                .fill(.white)
                                .frame(width: 2 * scaleX, height: 9 * scaleY)
                                .rotationEffect(.degrees(45))
                        }
                        .position(x: 228 * scaleX, y: 174 * scaleY)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .onAppear {
            if brewing {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    streamPhase = 10
                }
            }
        }
        .onChange(of: brewing) { _, newValue in
            if newValue {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    streamPhase = 10
                }
            } else {
                streamPhase = 0
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        EspressoMachineView(brewing: false)
            .frame(height: 300)
        EspressoMachineView(brewing: true)
            .frame(height: 300)
    }
    .padding()
    .background(Color.sbCanvas)
}

import SwiftUI

/// 照片正方形裁剪页，支持缩放、旋转、拖动，确认后回调裁剪结果
struct ImageCropView: View {
    let image: UIImage
    var initialScale: Double = 1.0
    var initialAngle: Double = 0.0
    var onCrop: (UIImage, Double, Double) -> Void  // 裁剪图、最终scale、最终angle

    @Environment(\.dismiss) private var dismiss

    // 已提交的变换状态
    @State private var scale: CGFloat = 1.0
    @State private var angle: Angle = .zero
    @State private var offset: CGSize = .zero

    // 手势进行中的增量
    @GestureState private var gestureScale: CGFloat = 1.0
    @GestureState private var gestureAngle: Angle = .zero
    @GestureState private var gestureDrag: CGSize = .zero

    private let cropSize: CGFloat = 280

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                // 裁剪预览区域
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: cropSize, height: cropSize)
                        .scaleEffect(scale * gestureScale)
                        .rotationEffect(angle + gestureAngle)
                        .offset(x: offset.width + gestureDrag.width,
                                y: offset.height + gestureDrag.height)
                        .clipShape(Circle())

                    // 引导圆框
                    Circle()
                        .strokeBorder(.white.opacity(0.5), lineWidth: 1.5)
                        .frame(width: cropSize, height: cropSize)
                }
                .gesture(
                    MagnificationGesture()
                        .updating($gestureScale) { val, state, _ in state = val }
                        .onEnded { val in
                            scale = max(0.5, min(5.0, scale * val))
                        }
                        .simultaneously(with:
                            RotationGesture()
                                .updating($gestureAngle) { val, state, _ in state = val }
                                .onEnded { val in angle += val }
                        )
                        .simultaneously(with:
                            DragGesture()
                                .updating($gestureDrag) { val, state, _ in state = val.translation }
                                .onEnded { val in
                                    offset = CGSize(
                                        width:  offset.width  + val.translation.width,
                                        height: offset.height + val.translation.height
                                    )
                                }
                        )
                )

                // 操作提示
                VStack {
                    Spacer()
                    Text("双指缩放 · 双指旋转 · 拖动调整位置")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.bottom, 100)
                }
            }
            .navigationTitle("裁剪图片")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                        .foregroundStyle(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("确认") {
                        let cropped = renderCrop()
                        onCrop(cropped, Double(scale * gestureScale), angle.degrees + gestureAngle.degrees)
                        dismiss()
                    }
                    .font(.sbBodyMB)
                    .foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            scale = CGFloat(initialScale)
            angle = .degrees(initialAngle)
        }
    }

    // MARK: - 渲染

    /// 将当前裁剪状态渲染为 400×400 UIImage
    private func renderCrop() -> UIImage {
        let outputSize = CGSize(width: 400, height: 400)
        let finalScale = scale * gestureScale
        let finalAngle = (angle + gestureAngle).radians
        let finalOffset = CGSize(
            width:  offset.width  + gestureDrag.width,
            height: offset.height + gestureDrag.height
        )

        return UIGraphicsImageRenderer(size: outputSize).image { ctx in
            let c = ctx.cgContext
            // 移到中心
            c.translateBy(x: outputSize.width / 2, y: outputSize.height / 2)
            // 应用旋转
            c.rotate(by: CGFloat(finalAngle))
            // 应用缩放
            c.scaleBy(x: CGFloat(finalScale), y: CGFloat(finalScale))
            // 移回并加上偏移
            let ratio = outputSize.width / cropSize
            c.translateBy(
                x: -outputSize.width / 2 + finalOffset.width * ratio,
                y: -outputSize.height / 2 + finalOffset.height * ratio
            )
            // 计算原图绘制区域（保持原图比例，以短边填满 outputSize）
            let imgSize = image.size
            let imgRatio = max(outputSize.width / imgSize.width, outputSize.height / imgSize.height)
            let drawW = imgSize.width  * imgRatio
            let drawH = imgSize.height * imgRatio
            let drawRect = CGRect(
                x: (outputSize.width  - drawW) / 2,
                y: (outputSize.height - drawH) / 2,
                width: drawW, height: drawH
            )
            image.draw(in: drawRect)
        }
    }
}

#Preview("图片裁剪页") {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 400))
    let img = renderer.image { ctx in
        UIColor.systemTeal.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 400, height: 400))
        UIColor.white.withAlphaComponent(0.4).setFill()
        ctx.fill(CGRect(x: 80, y: 80, width: 240, height: 240))
    }
    return ImageCropView(image: img, initialScale: 1.0, initialAngle: 0) { _, _, _ in }
}

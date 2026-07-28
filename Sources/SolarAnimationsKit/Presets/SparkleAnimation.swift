import SwiftUI
import UIKit

/// Sparkle 애니메이션 프리셋
///
/// 트위터(X)의 하트 버튼이나 인스타그램의 좋아요를 누를 때 주변으로 퍼지는 별빛/폭죽 효과입니다.
/// CAEmitterLayer를 활용하여 고성능으로 파티클을 흩뿌리며 긍정적인 피드백을 극대화합니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ✅ (선택적) — 트리거 시 `.success` 노티피케이션 햅틱 발생
/// - **입력 매개변수**:
///   - `isTriggered` (Bool, default: false): true로 변경 시 1회 폭죽 발사
///   - `color` (UIColor, default: .systemYellow): 파티클 색상
///   - `hapticsEnabled` (Bool, default: false): 햅틱 피드백 활성화 여부
/// - **관측 가능한 출력**: 없음
public struct SparkleAnimation: SolarAnimatable {
    public let id: String = "sparkle"
    public let displayName: String = "스파클 (별빛 폭죽)"
    public let description: String = "좋아요 버튼 등에 적합한 원형 파티클 폭발 효과입니다."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(classType: .linearPerFrame, recommendedMaxInstances: 5)
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "isTriggered", type: "Bool", defaultValue: "false", description: "true로 변경 시 1회 발사"),
        ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
    ])
    public let outputEffects: [ParameterInfo] = []
    public let iconName: String? = "sparkles"
    
    private let isTriggered: Bool
    private let color: UIColor
    private let hapticsEnabled: Bool
    
    public init(isTriggered: Bool, color: UIColor = .systemYellow, hapticsEnabled: Bool = false) {
        self.isTriggered = isTriggered
        self.color = color
        self.hapticsEnabled = hapticsEnabled
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation { .default }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        if !isTriggered { return [] }
        let shouldHaptic = hapticsEnabled
        let particleColor = color
        
        return [.custom({ @MainActor layer, _ in
            if shouldHaptic {
                HapticsGenerator.triggerNotification(type: .success)
            }
            let emitter = CAEmitterLayer()
            emitter.name = "SolarSparkleLayer"
            emitter.emitterPosition = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
            emitter.emitterShape = .circle
            emitter.emitterSize = layer.bounds.size
            emitter.emitterMode = .outline
            
            let cell = CAEmitterCell()
            cell.birthRate = 100
            cell.lifetime = 0.5
            cell.velocity = 60
            cell.velocityRange = 20
            cell.emissionRange = .pi * 2
            cell.scale = 0.1
            cell.scaleRange = 0.05
            cell.scaleSpeed = -0.1
            cell.alphaSpeed = -2.0
            
            let size = CGSize(width: 20, height: 20)
            let renderer = UIGraphicsImageRenderer(size: size)
            let image = renderer.image { ctx in
                particleColor.setFill()
                let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
                path.fill()
            }
            cell.contents = image.cgImage
            
            emitter.emitterCells = [cell]
            layer.addSublayer(emitter)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                emitter.birthRate = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                emitter.removeFromSuperlayer()
            }
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.overlay(
                    SparkleViewRepresentable(isTriggered: isTriggered, color: color, hapticsEnabled: hapticsEnabled)
                        .allowsHitTesting(false)
                )
            )
        }
    }
}

struct SparkleViewRepresentable: UIViewRepresentable {
    let isTriggered: Bool
    let color: UIColor
    let hapticsEnabled: Bool

    nonisolated init(isTriggered: Bool, color: UIColor, hapticsEnabled: Bool) {
        self.isTriggered = isTriggered
        self.color = color
        self.hapticsEnabled = hapticsEnabled
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if isTriggered {
            let anim = SparkleAnimation(isTriggered: true, color: color, hapticsEnabled: hapticsEnabled)
            if let command = anim.makeUIKitCommands().first {
                command.apply(on: uiView.layer, theme: .default)
            }
        }
    }
}

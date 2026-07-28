import SwiftUI
import UIKit

/// Confetti 애니메이션 프리셋
///
/// CAEmitterLayer 기반의 고성능 파티클 시스템을 활용한 축하 효과입니다.
/// 트리거 시 뷰 중앙에서 6색 꽃가루가 분출되어 중력의 영향을 받으며 자연스럽게 떨어집니다.
/// 결제 완료, 목표 달성, 레벨업 등 축하가 필요한 순간에 적합합니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ✅ (선택적) — 트리거 시 `.success` 노티피케이션 햅틱 발생
/// - **입력 매개변수**:
///   - `isTriggered` (Bool, default: false): true로 변경 시 1회 폭죽 발사
///   - `hapticsEnabled` (Bool, default: false): 햅틱 피드백 활성화 여부
/// - **관측 가능한 출력**: 없음 (파티클은 4초 후 자동 제거)
///
/// ## 사용 예시
/// ```swift
/// // SwiftUI
/// view.animationKitConfetti(isTriggered: true, hapticsEnabled: true)
///
/// // UIKit
/// view.animationKitConfetti(hapticsEnabled: true)
/// ```
public struct ConfettiAnimation: SolarAnimatable {
    public let id: String = "confetti"
    public let displayName: String = "컨페티 (축하 폭죽)"
    public let description: String = "CAEmitterLayer 기반 축하 파티클 효과. 결제 완료, 목표 달성 시 적합."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(
        classType: .linearPerFrame,
        recommendedMaxInstances: 1
    )
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "isTriggered", type: "Bool", defaultValue: "false", description: "true로 변경 시 1회 폭죽 발사"),
        ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
    ])
    public let outputEffects: [ParameterInfo] = []
    public let iconName: String? = "party.popper.fill"
    
    private let isTriggered: Bool
    private let hapticsEnabled: Bool
    
    public init(isTriggered: Bool, hapticsEnabled: Bool = false) {
        self.isTriggered = isTriggered
        self.hapticsEnabled = hapticsEnabled
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .default
    }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        if !isTriggered { return [] }
        
        let shouldHaptic = hapticsEnabled
        
        return [.custom({ @MainActor layer, _ in
            if shouldHaptic {
                HapticsGenerator.triggerNotification(type: .success)
            }
            
            let emitter = CAEmitterLayer()
            emitter.name = "SolarConfettiLayer"
            emitter.emitterPosition = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
            emitter.emitterSize = CGSize(width: layer.bounds.width, height: 1)
            emitter.emitterShape = .line
            
            let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemOrange, .systemPurple]
            
            emitter.emitterCells = colors.map { color in
                let cell = CAEmitterCell()
                cell.birthRate = 50
                cell.lifetime = 3.0
                cell.velocity = 300
                cell.velocityRange = 100
                cell.emissionLongitude = -.pi / 2
                cell.emissionRange = .pi / 4
                cell.spin = 2
                cell.spinRange = 4
                cell.scale = 0.5
                cell.scaleRange = 0.2
                cell.yAcceleration = 300
                
                let size = CGSize(width: 10, height: 10)
                let renderer = UIGraphicsImageRenderer(size: size)
                let image = renderer.image { ctx in
                    color.setFill()
                    ctx.fill(CGRect(origin: .zero, size: size))
                }
                cell.contents = image.cgImage
                
                return cell
            }
            
            layer.addSublayer(emitter)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                emitter.birthRate = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                emitter.removeFromSuperlayer()
            }
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.overlay(
                    ConfettiViewRepresentable(isTriggered: isTriggered, hapticsEnabled: hapticsEnabled)
                        .allowsHitTesting(false)
                )
            )
        }
    }
}

// MARK: - SwiftUI 브릿지
struct ConfettiViewRepresentable: UIViewRepresentable {
    let isTriggered: Bool
    let hapticsEnabled: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if isTriggered {
            let anim = ConfettiAnimation(isTriggered: true, hapticsEnabled: hapticsEnabled)
            if let command = anim.makeUIKitCommands().first {
                command.apply(on: uiView.layer, theme: .default)
            }
        }
    }
}

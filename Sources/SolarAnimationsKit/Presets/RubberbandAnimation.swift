import SwiftUI
import UIKit

/// Rubberband 애니메이션 프리셋
///
/// 뷰를 드래그할 때 한계치에 다다르면 스프링처럼 저항(Tension)이 발생하고, 놓으면 원래 자리로 튕겨 돌아가는 효과입니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ✅ (선택적) — 최대 드래그 거리에 도달하거나 놓았을 때 햅틱 발생
/// - **입력 매개변수**:
///   - `tension` (CGFloat, default: 0.5): 고무줄 저항 강도 (낮을수록 저항 강함)
///   - `hapticsEnabled` (Bool, default: false): 햅틱 활성화 여부
/// - **관측 가능한 출력**: 드래그 오프셋
public struct RubberbandAnimation: SolarAnimatable {
    public let id: String = "rubberband"
    public let displayName: String = "러버밴드 (고무줄 당기기)"
    public let description: String = "드래그 시 물리적인 저항을 느끼게 하고 놓으면 원래 자리로 튕겨 돌아갑니다."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(classType: .cpuBound, recommendedMaxInstances: 5)
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "tension", type: "CGFloat", defaultValue: "0.5", description: "고무줄 저항 강도"),
        ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
    ])
    public let outputEffects: [ParameterInfo] = []
    public let iconName: String? = "arrow.up.and.down.and.arrow.left.and.right"
    
    private let tension: CGFloat
    private let hapticsEnabled: Bool
    
    public init(tension: CGFloat = 0.5, hapticsEnabled: Bool = false) {
        self.tension = tension
        self.hapticsEnabled = hapticsEnabled
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .interpolatingSpring(mass: 1.0, stiffness: 150, damping: 15, initialVelocity: 0)
    }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        let t = tension
        let shouldHaptic = hapticsEnabled
        
        return [.custom({ @MainActor layer, _ in
            guard let view = layer.delegate as? UIView else { return }
            
            // In UIKit, the easiest way to inject a drag gesture cleanly for a preset is to attach a pan gesture recognizer.
            // However, adding state to layer custom command requires associated objects or gesture sub-management.
            // For simplicity in this preset, we attach a UIPanGestureRecognizer.
            
            // Remove existing one if added before
            if let gestures = view.gestureRecognizers {
                for gesture in gestures where gesture.name == "SolarRubberband" {
                    view.removeGestureRecognizer(gesture)
                }
            }
            
            let panGesture = RubberbandPanGestureRecognizer(target: nil, action: nil)
            panGesture.name = "SolarRubberband"
            panGesture.tension = t
            panGesture.hapticsEnabled = shouldHaptic
            view.addGestureRecognizer(panGesture)
            view.isUserInteractionEnabled = true
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                RubberbandModifier(tension: tension, hapticsEnabled: hapticsEnabled, content: view)
            )
        }
    }
}

// MARK: - SwiftUI Modifier
struct RubberbandModifier: View {
    let tension: CGFloat
    let hapticsEnabled: Bool
    let content: AnyView
    
    @State private var offset: CGSize = .zero

    nonisolated init(tension: CGFloat, hapticsEnabled: Bool, content: AnyView) {
        self.tension = tension
        self.hapticsEnabled = hapticsEnabled
        self.content = content
    }
    
    var body: some View {
        content
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Apply logarithmic rubberband formula
                        let dx = value.translation.width
                        let dy = value.translation.height
                        
                        let tx = dx > 0 ? pow(dx, tension) : -pow(-dx, tension)
                        let ty = dy > 0 ? pow(dy, tension) : -pow(-dy, tension)
                        
                        offset = CGSize(width: tx * 5, height: ty * 5) // Scale up slightly to make it feel better
                    }
                    .onEnded { _ in
                        if hapticsEnabled {
                            HapticsGenerator.triggerImpact(style: .light)
                        }
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 150, damping: 15)) {
                            offset = .zero
                        }
                    }
            )
    }
}

// MARK: - UIKit Gesture
class RubberbandPanGestureRecognizer: UIPanGestureRecognizer {
    var tension: CGFloat = 0.5
    var hapticsEnabled: Bool = false
    
    private var initialCenter: CGPoint = .zero
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.addTarget(self, action: #selector(handlePan(_:)))
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            initialCenter = view.center
        case .changed:
            let translation = gesture.translation(in: view.superview)
            let dx = translation.x
            let dy = translation.y
            
            let tx = dx > 0 ? pow(dx, tension) : -pow(-dx, tension)
            let ty = dy > 0 ? pow(dy, tension) : -pow(-dy, tension)
            
            view.center = CGPoint(x: initialCenter.x + (tx * 5), y: initialCenter.y + (ty * 5))
            
        case .ended, .cancelled:
            if hapticsEnabled {
                HapticsGenerator.triggerImpact(style: .light)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                view.center = self.initialCenter
            })
            
        default:
            break
        }
    }
}

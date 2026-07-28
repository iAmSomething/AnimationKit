import SwiftUI
import UIKit

/// Ripple 애니메이션 프리셋
///
/// 터치 지점에서 물결이 퍼져나가는 Material Design 스타일의 잉크 드롭 효과입니다.
/// 탭한 좌표(origin)를 기준으로 원형 레이어가 확대되며 페이드아웃됩니다.
/// 리스트 아이템 선택, 커스텀 버튼 탭 피드백, 크로스 플랫폼 디자인 시스템에 적합합니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ✅ (선택적) — 탭 시 `.medium` 임팩트 햅틱 발생
/// - **입력 매개변수**:
///   - `origin` (CGPoint, default: .zero): 리플 시작 좌표 (뷰 내부 로컬 좌표)
///   - `color` (UIColor, default: .systemBlue): 리플 색상
///   - `hapticsEnabled` (Bool, default: false): 햅틱 피드백 활성화 여부
/// - **관측 가능한 출력**:
///   - `rippleRadius` (CGFloat): 최종 리플 반경
///
/// ## 사용 예시
/// ```swift
/// // SwiftUI
/// view.animationKitRipple(at: tapLocation, hapticsEnabled: true)
///
/// // UIKit
/// view.animationKitRipple(at: touchPoint, hapticsEnabled: true)
/// ```
public struct RippleAnimation: SolarAnimatable {
    public let id: String = "ripple"
    public let displayName: String = "리플 (물결 확산)"
    public let description: String = "터치 지점에서 퍼져나가는 잉크 드롭 효과. 버튼 탭 피드백에 적합."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(
        classType: .linearPerFrame,
        recommendedMaxInstances: 10
    )
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "origin", type: "CGPoint", defaultValue: ".zero", description: "리플 시작 좌표 (뷰 내부 로컬 좌표)"),
        ParameterInfo(name: "color", type: "UIColor", defaultValue: ".systemBlue", description: "리플 색상"),
        ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
    ])
    public let outputEffects: [ParameterInfo] = [
        ParameterInfo(name: "rippleRadius", type: "CGFloat", description: "최종 리플 반경")
    ]
    public let iconName: String? = "drop.circle.fill"
    
    private let origin: CGPoint
    private let color: UIColor
    private let hapticsEnabled: Bool
    
    public init(origin: CGPoint = .zero, color: UIColor = .systemBlue, hapticsEnabled: Bool = false) {
        self.origin = origin
        self.color = color
        self.hapticsEnabled = hapticsEnabled
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .easeOut(duration: 0.6)
    }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        let rippleOrigin = origin
        let rippleColor = color
        let haptic = hapticsEnabled
        
        return [.custom({ @MainActor layer, _ in
            if haptic {
                HapticsGenerator.triggerImpact(style: .medium)
            }
            
            // 리플이 뷰 전체를 덮을 수 있는 최대 반경 계산
            let maxDistX = max(rippleOrigin.x, layer.bounds.width - rippleOrigin.x)
            let maxDistY = max(rippleOrigin.y, layer.bounds.height - rippleOrigin.y)
            let maxRadius = sqrt(maxDistX * maxDistX + maxDistY * maxDistY)
            
            let rippleLayer = CAShapeLayer()
            rippleLayer.name = "SolarRippleLayer"
            let finalRect = CGRect(
                x: rippleOrigin.x - maxRadius,
                y: rippleOrigin.y - maxRadius,
                width: maxRadius * 2,
                height: maxRadius * 2
            )
            rippleLayer.path = UIBezierPath(ovalIn: finalRect).cgPath
            rippleLayer.fillColor = rippleColor.withAlphaComponent(0.3).cgColor
            rippleLayer.opacity = 0
            
            layer.addSublayer(rippleLayer)
            
            // Scale 애니메이션
            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = 0.0
            scaleAnim.toValue = 1.0
            
            // Opacity 애니메이션
            let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnim.values = [0.6, 0.4, 0.0]
            opacityAnim.keyTimes = [0.0, 0.4, 1.0]
            
            let group = CAAnimationGroup()
            group.animations = [scaleAnim, opacityAnim]
            group.duration = 0.6
            group.timingFunction = CAMediaTimingFunction(name: .easeOut)
            group.isRemovedOnCompletion = true
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                rippleLayer.removeFromSuperlayer()
            }
            rippleLayer.add(group, forKey: "ripple")
            CATransaction.commit()
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.modifier(
                    RippleModifier(
                        origin: origin,
                        color: Color(color),
                        hapticsEnabled: hapticsEnabled
                    )
                )
            )
        }
    }
}

// MARK: - SwiftUI Modifier
struct RippleModifier: ViewModifier {
    let origin: CGPoint
    let color: Color
    let hapticsEnabled: Bool
    
    @State private var rippleScale: CGFloat = 0
    @State private var rippleOpacity: Double = 0.6
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    let maxDist = sqrt(
                        pow(max(origin.x, geo.size.width - origin.x), 2) +
                        pow(max(origin.y, geo.size.height - origin.y), 2)
                    )
                    Circle()
                        .fill(color.opacity(rippleOpacity))
                        .frame(width: maxDist * 2, height: maxDist * 2)
                        .position(x: origin.x, y: origin.y)
                        .scaleEffect(rippleScale)
                }
                .allowsHitTesting(false)
            )
            .clipped()
            .onAppear {
                guard !isAnimating else { return }
                isAnimating = true
                withAnimation(.easeOut(duration: 0.6)) {
                    rippleScale = 1.0
                    rippleOpacity = 0.0
                }
            }
    }
}

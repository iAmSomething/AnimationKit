import SwiftUI
import UIKit

/// 3D Tilt 애니메이션 프리셋
///
/// 드래그 제스처에 반응하여 뷰가 3D로 기울어지는 패럴랙스 효과입니다.
/// Apple TV의 포커스 효과나 앱스토어 Today 탭 카드 인터랙션과 유사합니다.
/// 드래그 방향에 따라 X/Y축으로 입체적으로 회전하며, 반사광(Specular) 오버레이가 함께 이동합니다.
/// 프리미엄 멤버십 카드, 앨범 커버, 인터랙티브 카드 UI에 적합합니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ✅ (선택적) — 틸트가 최대 각도에 도달 시 `selection` 햅틱 발생
/// - **입력 매개변수**:
///   - `maxAngle` (Double, default: 15.0): 최대 기울기 각도 (도 단위)
///   - `perspective` (CGFloat, default: 0.5): 원근감 강도 (0.0~1.0)
///   - `hapticsEnabled` (Bool, default: false): 햅틱 피드백 활성화 여부
/// - **관측 가능한 출력**:
///   - `rotationX` (Double): 현재 X축 회전 각도
///   - `rotationY` (Double): 현재 Y축 회전 각도
///
/// ## 사용 예시
/// ```swift
/// // SwiftUI
/// view.animationKitTilt3D(maxAngle: 15, hapticsEnabled: true)
///
/// // UIKit
/// view.animationKitTilt3D(maxAngle: 15, hapticsEnabled: true)
/// ```
public struct Tilt3DAnimation: SolarAnimatable {
    public let id: String = "tilt3d"
    public let displayName: String = "3D 틸트 (패럴랙스)"
    public let description: String = "드래그 기반 3D 패럴랙스 카드 효과. 프리미엄 카드, 앨범 커버에 적합."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(
        classType: .gpuOptimized,
        recommendedMaxInstances: 10
    )
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "maxAngle", type: "Double", defaultValue: "15.0", description: "최대 기울기 각도 (도 단위)"),
        ParameterInfo(name: "perspective", type: "CGFloat", defaultValue: "0.5", description: "원근감 강도 (0.0~1.0)"),
        ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
    ])
    public let outputEffects: [ParameterInfo] = [
        ParameterInfo(name: "rotationX", type: "Double", description: "현재 X축 회전 각도"),
        ParameterInfo(name: "rotationY", type: "Double", description: "현재 Y축 회전 각도")
    ]
    public let iconName: String? = "rotate.3d.fill"
    
    private let maxAngle: Double
    private let perspective: CGFloat
    private let hapticsEnabled: Bool
    
    public init(maxAngle: Double = 15.0, perspective: CGFloat = 0.5, hapticsEnabled: Bool = false) {
        self.maxAngle = maxAngle
        self.perspective = perspective
        self.hapticsEnabled = hapticsEnabled
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .interactiveSpring(response: 0.3, dampingFraction: 0.6)
    }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        let angle = maxAngle
        let persp = perspective
        
        return [.custom({ @MainActor layer, _ in
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / (500.0 * persp)
            transform = CATransform3DRotate(transform, CGFloat(angle * .pi / 180), 1, 0, 0)
            transform = CATransform3DRotate(transform, CGFloat(angle * .pi / 180), 0, 1, 0)
            
            let anim = CABasicAnimation(keyPath: "transform")
            anim.fromValue = CATransform3DIdentity
            anim.toValue = transform
            anim.duration = 0.3
            anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
            anim.autoreverses = true
            
            layer.add(anim, forKey: "tilt3d")
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.modifier(
                    Tilt3DModifier(
                        maxAngle: maxAngle,
                        perspective: perspective,
                        hapticsEnabled: hapticsEnabled
                    )
                )
            )
        }
    }
}

// MARK: - SwiftUI Modifier
struct Tilt3DModifier: ViewModifier {
    let maxAngle: Double
    let perspective: CGFloat
    let hapticsEnabled: Bool
    
    @State private var dragOffset: CGSize = .zero
    @State private var hasReachedEdge = false
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            let normalizedX = dragOffset.width / (geo.size.width / 2)
            let normalizedY = dragOffset.height / (geo.size.height / 2)
            
            let rotX = -normalizedY * maxAngle
            let rotY = normalizedX * maxAngle
            
            content
                .rotation3DEffect(
                    .degrees(rotX),
                    axis: (x: 1, y: 0, z: 0),
                    perspective: perspective
                )
                .rotation3DEffect(
                    .degrees(rotY),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: perspective
                )
                .overlay(
                    // Specular 반사광 오버레이
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.0),
                            .white.opacity(0.15),
                            .white.opacity(0.0)
                        ]),
                        startPoint: UnitPoint(
                            x: 0.5 + normalizedX * 0.3,
                            y: 0.5 + normalizedY * 0.3
                        ),
                        endPoint: UnitPoint(
                            x: 0.5 - normalizedX * 0.3,
                            y: 0.5 - normalizedY * 0.3
                        )
                    )
                    .allowsHitTesting(false)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.6)) {
                                dragOffset = value.translation
                            }
                            
                            // 가장자리 도달 시 햅틱
                            let atEdge = abs(normalizedX) > 0.9 || abs(normalizedY) > 0.9
                            if hapticsEnabled && atEdge && !hasReachedEdge {
                                hasReachedEdge = true
                                HapticsGenerator.triggerSelection()
                            } else if !atEdge {
                                hasReachedEdge = false
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5)) {
                                dragOffset = .zero
                            }
                            hasReachedEdge = false
                        }
                )
        }
    }
}

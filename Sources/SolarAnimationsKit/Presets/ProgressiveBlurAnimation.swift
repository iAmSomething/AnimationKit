import SwiftUI
import UIKit

/// Progressive Blur 애니메이션 프리셋
///
/// 뷰의 일부분부터 서서히 블러(흐림) 처리가 강해지는 고급 시각 효과입니다.
/// 가사창 배경이나 네비게이션 바 하단처럼 프리미엄한 Glassmorphism 효과를 줍니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ❌
/// - **입력 매개변수**:
///   - `blurStyle` (UIBlurEffect.Style, default: .regular): 블러 스타일
///   - `direction` (Direction, default: .bottomToTop): 블러가 진해지는 방향
/// - **관측 가능한 출력**: 없음
public struct ProgressiveBlurAnimation: SolarAnimatable {
    public enum Direction: Sendable {
        case topToBottom, bottomToTop, leftToRight, rightToLeft
    }
    
    public let id: String = "progressiveBlur"
    public let displayName: String = "점진적 블러 (Progressive Blur)"
    public let description: String = "그라데이션 마스크를 통해 서서히 흐려지는 블러 효과를 제공합니다."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(classType: .gpuOptimized, recommendedMaxInstances: 2)
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "blurStyle", type: "UIBlurEffect.Style", defaultValue: ".regular", description: "블러 스타일"),
        ParameterInfo(name: "direction", type: "Direction", defaultValue: ".bottomToTop", description: "블러 방향")
    ])
    public let outputEffects: [ParameterInfo] = []
    public let iconName: String? = "drop.degreesign"
    
    private let blurStyle: UIBlurEffect.Style
    private let direction: Direction
    
    public init(blurStyle: UIBlurEffect.Style = .regular, direction: Direction = .bottomToTop) {
        self.blurStyle = blurStyle
        self.direction = direction
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation { .default }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        let style = blurStyle
        let dir = direction
        
        return [.custom({ @MainActor layer, _ in
            guard let view = layer.delegate as? UIView else { return }
            
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
            blurView.frame = view.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView.isUserInteractionEnabled = false
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = blurView.bounds
            
            let transparent = UIColor.clear.cgColor
            let opaque = UIColor.black.cgColor
            
            switch dir {
            case .topToBottom:
                gradientLayer.colors = [transparent, opaque]
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            case .bottomToTop:
                gradientLayer.colors = [opaque, transparent]
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            case .leftToRight:
                gradientLayer.colors = [transparent, opaque]
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            case .rightToLeft:
                gradientLayer.colors = [opaque, transparent]
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            }
            
            blurView.layer.mask = gradientLayer
            view.addSubview(blurView)
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.overlay(
                    ProgressiveBlurViewRepresentable(blurStyle: blurStyle, direction: direction)
                        .allowsHitTesting(false)
                )
            )
        }
    }
}

struct ProgressiveBlurViewRepresentable: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style
    let direction: ProgressiveBlurAnimation.Direction

    nonisolated init(blurStyle: UIBlurEffect.Style, direction: ProgressiveBlurAnimation.Direction) {
        self.blurStyle = blurStyle
        self.direction = direction
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        let anim = ProgressiveBlurAnimation(blurStyle: blurStyle, direction: direction)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: uiView.layer, theme: .default)
        }
    }
}

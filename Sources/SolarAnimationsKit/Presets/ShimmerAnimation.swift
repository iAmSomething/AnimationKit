import SwiftUI
import UIKit

/// Shimmer 애니메이션 프리셋
///
/// 스켈레톤 UI 로딩 화면에서 자주 사용되는 빛 반사 효과입니다.
/// 뷰 위에 반투명 그라데이션이 수평으로 반복 이동하며 로딩 중임을 시각적으로 표현합니다.
/// 콘텐츠 피드, 프로필 카드, 리스트 셀의 로딩 플레이스홀더에 적합합니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ❌
/// - **입력 매개변수**:
///   - `isPlaying` (Bool, default: true): 애니메이션 재생 여부. false로 설정 시 기존 시머 레이어 제거
/// - **관측 가능한 출력**: 없음 (순수 시각 효과)
///
/// ## 사용 예시
/// ```swift
/// // SwiftUI
/// view.animationKitShimmer(isPlaying: true)
///
/// // UIKit
/// view.animationKitShimmer(isPlaying: true)
/// ```
public struct ShimmerAnimation: SolarAnimatable {
    public let id: String = "shimmer"
    public let displayName: String = "시머 (빛 반사)"
    public let description: String = "스켈레톤 UI 로딩 화면의 빛 반사 효과. 콘텐츠 피드, 프로필 카드 플레이스홀더에 적합."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(
        classType: .gpuOptimized,
        recommendedMaxInstances: 50
    )
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "isPlaying", type: "Bool", defaultValue: "true", description: "애니메이션 재생 여부. false 시 시머 레이어 제거")
    ])
    public let outputEffects: [ParameterInfo] = []
    public let iconName: String? = "sparkles.rectangle"
    
    private let isPlaying: Bool
    
    public init(isPlaying: Bool = true) {
        self.isPlaying = isPlaying
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .linear(duration: 1.5).repeatForever(autoreverses: false)
    }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        if !isPlaying {
            return [.custom({ @MainActor layer, _ in
                layer.sublayers?.filter { $0.name == "SolarShimmerLayer" }.forEach { $0.removeFromSuperlayer() }
            })]
        }
        
        return [.custom({ @MainActor layer, duration in
            layer.sublayers?.filter { $0.name == "SolarShimmerLayer" }.forEach { $0.removeFromSuperlayer() }
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.name = "SolarShimmerLayer"
            gradientLayer.frame = layer.bounds
            
            let lightColor = UIColor.white.withAlphaComponent(0.6).cgColor
            let darkColor = UIColor.white.withAlphaComponent(0.1).cgColor
            
            gradientLayer.colors = [darkColor, lightColor, darkColor]
            gradientLayer.locations = [0.0, 0.5, 1.0]
            
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            layer.addSublayer(gradientLayer)
            
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = [-1.0, -0.5, 0.0]
            animation.toValue = [1.0, 1.5, 2.0]
            animation.duration = 1.5
            animation.repeatCount = .infinity
            
            gradientLayer.add(animation, forKey: "shimmer")
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(view.modifier(ShimmerModifier(isPlaying: isPlaying)))
        }
    }
}

struct ShimmerModifier: ViewModifier {
    let isPlaying: Bool
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    if isPlaying {
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .white.opacity(0.6), .clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geo.size.width * 2)
                        .offset(x: -geo.size.width + geo.size.width * 3 * phase)
                        .blendMode(.screen)
                        .onAppear {
                            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                                phase = 1.0
                            }
                        }
                    }
                }
            )
            .mask(content)
    }
}

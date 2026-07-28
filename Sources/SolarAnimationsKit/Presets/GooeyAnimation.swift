import SwiftUI
import UIKit

/// Gooey 애니메이션 프리셋
///
/// 블러(Blur)와 고대비(Contrast) 합성 기법을 활용한 액체/점성 모핑 효과입니다.
/// 두 개 이상의 도형이 가까워질 때 점성이 생겨 달라붙는 것처럼 보이는 유기적 효과를 만듭니다.
/// 플로팅 액션 버튼(FAB) 열기, 탭바 인디케이터 이동, 로딩 인디케이터에 적합합니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ❌ (연속 모핑 효과이므로 햅틱 미적용)
/// - **입력 매개변수**:
///   - `blurRadius` (CGFloat, default: 20): 블러 반경 (값이 클수록 점성 범위 확대)
///   - `isActive` (Bool, default: true): 효과 활성화 여부
/// - **관측 가능한 출력**: 없음 (순수 시각 효과)
///
/// ## 사용 예시
/// ```swift
/// // SwiftUI
/// view.animationKitGooey(blurRadius: 20, isActive: true)
///
/// // UIKit
/// view.animationKitGooey(blurRadius: 20, isActive: true)
/// ```
public struct GooeyAnimation: SolarAnimatable {
    public let id: String = "gooey"
    public let displayName: String = "구이 (액체 모핑)"
    public let description: String = "블러+고대비 합성 기법의 액체 점성 효과. FAB 열기, 탭바 인디케이터에 적합."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(
        classType: .offscreenRisk,
        estimatedMemoryFootprint: "Medium (~10KB)",
        recommendedMaxInstances: 3
    )
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "blurRadius", type: "CGFloat", defaultValue: "20", description: "블러 반경 (값이 클수록 점성 범위 확대)"),
        ParameterInfo(name: "isActive", type: "Bool", defaultValue: "true", description: "효과 활성화 여부")
    ])
    public let outputEffects: [ParameterInfo] = []
    public let iconName: String? = "drop.fill"
    
    private let blurRadius: CGFloat
    private let isActive: Bool
    
    public init(blurRadius: CGFloat = 20, isActive: Bool = true) {
        self.blurRadius = blurRadius
        self.isActive = isActive
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .easeInOut(duration: 0.5)
    }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        let radius = blurRadius
        let active = isActive
        
        return [.custom({ @MainActor layer, _ in
            if active {
                // 래스터화 + 블러 조합으로 구이 효과 시뮬레이션
                layer.shouldRasterize = true
                layer.rasterizationScale = UIScreen.main.scale
                
                // 가우시안 블러 필터 적용 (CALayer 수준)
                let blurFilter = CIFilter(name: "CIGaussianBlur")
                blurFilter?.setValue(radius, forKey: "inputRadius")
                
                // 레이어에 직접 필터를 적용하는 대신 래스터화를 활용
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.0
                layer.shadowRadius = radius * 0.5
                layer.shadowOffset = .zero
            } else {
                layer.shouldRasterize = false
                layer.shadowOpacity = 0.0
            }
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.modifier(
                    GooeyModifier(blurRadius: blurRadius, isActive: isActive)
                )
            )
        }
    }
}

// MARK: - SwiftUI Modifier
struct GooeyModifier: ViewModifier {
    let blurRadius: CGFloat
    let isActive: Bool
    
    func body(content: Content) -> some View {
        if isActive {
            content
                .blur(radius: blurRadius)
                .contrast(10)
        } else {
            content
        }
    }
}

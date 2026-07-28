import SwiftUI
import UIKit

/// Pulse 애니메이션 프리셋
///
/// 뷰 주위로 은은한 원형 파장이 무한히 퍼져나가며 사라지는 호흡(Breathe) 효과입니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ❌
/// - **입력 매개변수**:
///   - `isActive` (Bool, default: true): 활성화 여부
///   - `color` (UIColor, default: .systemBlue): 파장 색상
///   - `duration` (TimeInterval, default: 2.0): 파장 1주기 시간
///   - `scale` (CGFloat, default: 1.5): 파장이 최대로 커지는 비율
/// - **관측 가능한 출력**: 없음
public struct PulseAnimation: SolarAnimatable {
    public let id: String = "pulse"
    public let displayName: String = "펄스 (파장 숨쉬기)"
    public let description: String = "라이브 인디케이터나 녹음 버튼 등에 사용되는 무한 파장 효과입니다."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(classType: .linearPerFrame, recommendedMaxInstances: 5)
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "isActive", type: "Bool", defaultValue: "true", description: "애니메이션 활성화 여부"),
        ParameterInfo(name: "color", type: "UIColor", defaultValue: ".systemBlue", description: "파장 색상"),
        ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "2.0", description: "파장 1주기 시간"),
        ParameterInfo(name: "scale", type: "CGFloat", defaultValue: "1.5", description: "파장 최대 크기 비율")
    ])
    public let outputEffects: [ParameterInfo] = []
    public let iconName: String? = "waveform.circle"
    
    private let isActive: Bool
    private let color: UIColor
    private let duration: TimeInterval
    private let scale: CGFloat
    
    public init(isActive: Bool = true, color: UIColor = .systemBlue, duration: TimeInterval = 2.0, scale: CGFloat = 1.5) {
        self.isActive = isActive
        self.color = color
        self.duration = duration
        self.scale = scale
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation { .easeOut(duration: duration).repeatForever(autoreverses: false) }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        if !isActive { return [] }
        let c = color
        let dur = duration
        let s = scale
        
        return [.custom({ @MainActor layer, _ in
            let pulseLayer = CALayer()
            pulseLayer.name = "SolarPulseLayer"
            pulseLayer.backgroundColor = c.cgColor
            pulseLayer.bounds = layer.bounds
            pulseLayer.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
            pulseLayer.cornerRadius = min(layer.bounds.width, layer.bounds.height) / 2
            pulseLayer.opacity = 0
            
            // Insert behind the main content if possible
            if let superlayer = layer.superlayer {
                superlayer.insertSublayer(pulseLayer, below: layer)
            } else {
                layer.addSublayer(pulseLayer)
            }
            
            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = 1.0
            scaleAnim.toValue = s
            
            let alphaAnim = CABasicAnimation(keyPath: "opacity")
            alphaAnim.fromValue = 0.6
            alphaAnim.toValue = 0.0
            
            let group = CAAnimationGroup()
            group.animations = [scaleAnim, alphaAnim]
            group.duration = dur
            group.repeatCount = .infinity
            group.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            pulseLayer.add(group, forKey: "pulseAnimation")
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.modifier(PulseModifier(isActive: isActive, color: Color(color), duration: duration, scale: scale))
            )
        }
    }
}

struct PulseModifier: ViewModifier {
    let isActive: Bool
    let color: Color
    let duration: TimeInterval
    let scale: CGFloat
    
    @State private var isAnimating: Bool = false

    nonisolated init(isActive: Bool, color: Color, duration: TimeInterval, scale: CGFloat) {
        self.isActive = isActive
        self.color = color
        self.duration = duration
        self.scale = scale
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                Circle()
                    .fill(color)
                    .scaleEffect(isAnimating ? scale : 1.0)
                    .opacity(isAnimating ? 0.0 : 0.6)
                    .onAppear {
                        if isActive {
                            withAnimation(.easeOut(duration: duration).repeatForever(autoreverses: false)) {
                                isAnimating = true
                            }
                        }
                    }
            )
            .onChange(of: isActive) { active in
                if active {
                    withAnimation(.easeOut(duration: duration).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                } else {
                    withAnimation {
                        isAnimating = false
                    }
                }
            }
    }
}

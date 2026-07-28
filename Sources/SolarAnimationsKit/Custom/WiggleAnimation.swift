import SwiftUI
import UIKit

public struct WiggleAnimation: SolarAnimatable {
    public let id: String = "custom_wiggle"
    public let displayName: String = "Wiggle"
    public let description: String = "뷰를 X축 방향으로 랜덤하게 흔들어 주의를 끕니다. Shake보다 더 불규칙하고 빠른 떨림입니다."
    public let category: String = "Feedback"
    public let performance: PerformanceProfile = PerformanceProfile(
        classType: .linearPerFrame,
        estimatedMemoryFootprint: "Low (<1KB)",
        mainThreadBlocking: true,
        needsRasterization: false,
        recommendedMaxInstances: 10,
        potentialLeakRisk: false
    )
    public let inputSchema: AnimationInputSchema = AnimationInputSchema([
        ParameterInfo(name: "intensity", type: "CGFloat", defaultValue: "5.0", description: "흔들림 강도 (픽셀)", isOptional: true),
        ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "0.3", description: "지속 시간", isOptional: true),
        ParameterInfo(name: "frequency", type: "CGFloat", defaultValue: "10.0", description: "초당 흔들림 횟수 (Hz)", isOptional: true)
    ])
    public let outputEffects: [ParameterInfo] = [
        ParameterInfo(name: "center.x", type: "CGFloat", description: "불규칙하게 변동하는 X좌표")
    ]
    public let iconName: String? = "wave.three.left"

    private let intensity: CGFloat
    private let duration: TimeInterval
    private let frequency: CGFloat

    public init(
        intensity: CGFloat = 5.0,
        duration: TimeInterval = 0.3,
        frequency: CGFloat = 10.0
    ) {
        self.intensity = intensity
        self.duration = duration
        self.frequency = frequency
    }

    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .easeInOut(duration: duration / Double(frequency))
    }

    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        [.wiggle(intensity: intensity, duration: duration, frequency: frequency)]
    }

    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        { $0 }
    }
}

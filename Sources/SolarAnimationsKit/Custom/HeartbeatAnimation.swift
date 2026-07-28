import SwiftUI
import UIKit

public struct HeartbeatAnimation: SolarAnimatable {
    public let id: String = "custom_heartbeat"
    public let displayName: String = "Heartbeat"
    public let description: String = "심장이 두 번 뛰는 듯한 리듬으로 스케일을 진동시킵니다. 알림, 관심 유도, 중요 표시용."
    public let category: String = "Feedback"
    public let performance: PerformanceProfile = PerformanceProfile(
        classType: .gpuOptimized,
        estimatedMemoryFootprint: "Low (<1KB)",
        mainThreadBlocking: false,
        needsRasterization: false,
        recommendedMaxInstances: 50,
        potentialLeakRisk: false
    )
    public let inputSchema: AnimationInputSchema = AnimationInputSchema([
        ParameterInfo(name: "scale", type: "CGFloat", defaultValue: "1.1", description: "최대 스케일 값", isOptional: true),
        ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "0.8", description: "1회 사이클 지속 시간", isOptional: true),
        ParameterInfo(name: "repeatCount", type: "Int", defaultValue: "3", description: "반복 횟수", isOptional: true)
    ])
    public let outputEffects: [ParameterInfo] = [
        ParameterInfo(name: "transform.scale", type: "CGFloat", description: "1.0 → scale → 1.0 → scale → 1.0")
    ]
    public let iconName: String? = "heart.fill"

    private let scale: CGFloat
    private let duration: TimeInterval
    private let repeatCount: Int

    public init(
        scale: CGFloat = 1.1,
        duration: TimeInterval = 0.8,
        repeatCount: Int = 3
    ) {
        self.scale = scale
        self.duration = duration
        self.repeatCount = repeatCount
    }

    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .interpolatingSpring(mass: 1, stiffness: 100, damping: 0.6, initialVelocity: 0)
            .speed(1)
            .repeatCount(repeatCount, autoreverses: true)
    }

    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        [.scale(to: scale, duration: duration * 0.3),
         .scale(to: 1.0, duration: duration * 0.2),
         .scale(to: scale, duration: duration * 0.3),
         .scale(to: 1.0, duration: duration * 0.2)]
    }

    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        { $0 }
    }
}

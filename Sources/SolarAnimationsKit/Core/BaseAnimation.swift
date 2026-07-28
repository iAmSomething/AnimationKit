import SwiftUI
import UIKit

public struct BaseAnimation: SolarAnimatable {
    public let id: String
    public let displayName: String
    public let description: String
    public let category: String
    public let performance: PerformanceProfile
    public let inputSchema: AnimationInputSchema
    public let outputEffects: [ParameterInfo]
    public let iconName: String?

    public let makeSwiftUIAnimationClosure: @Sendable () -> SwiftUI.Animation
    public let makeUIKitCommandsClosure: @Sendable () -> [AnimatableLayerCommand]
    public let makeSwiftUIModifierClosure: (@Sendable () -> (AnyView) -> AnyView)?

    public init(
        id: String,
        displayName: String,
        description: String,
        category: String,
        performance: PerformanceProfile,
        inputSchema: AnimationInputSchema,
        outputEffects: [ParameterInfo] = [],
        iconName: String? = nil,
        makeSwiftUIAnimation: @escaping @Sendable () -> SwiftUI.Animation,
        makeUIKitCommands: @escaping @Sendable () -> [AnimatableLayerCommand],
        makeSwiftUIModifier: (@Sendable () -> (AnyView) -> AnyView)? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.description = description
        self.category = category
        self.performance = performance
        self.inputSchema = inputSchema
        self.outputEffects = outputEffects
        self.iconName = iconName
        self.makeSwiftUIAnimationClosure = makeSwiftUIAnimation
        self.makeUIKitCommandsClosure = makeUIKitCommands
        self.makeSwiftUIModifierClosure = makeSwiftUIModifier
    }

    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        makeSwiftUIAnimationClosure()
    }

    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        makeUIKitCommandsClosure()
    }

    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        makeSwiftUIModifierClosure?() ?? { $0 }
    }
}

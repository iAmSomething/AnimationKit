import SwiftUI
import UIKit

// MARK: - Input Schema

public struct AnimationInputSchema: Sendable {
    public let properties: [ParameterInfo]

    public init(_ properties: [ParameterInfo]) {
        self.properties = properties
    }

    public var optionalProperties: [ParameterInfo] {
        properties.filter { $0.isOptional }
    }

    public var requiredProperties: [ParameterInfo] {
        properties.filter { !$0.isOptional }
    }
}

// MARK: - Core Protocol

public protocol SolarAnimatable: Sendable {
    var id: String { get }
    var displayName: String { get }
    var description: String { get }
    var category: String { get }
    var performance: PerformanceProfile { get }
    var inputSchema: AnimationInputSchema { get }
    var outputEffects: [ParameterInfo] { get }
    var iconName: String? { get }

    @MainActor func makeSwiftUIAnimation() -> SwiftUI.Animation
    @MainActor func makeUIKitCommands() -> [AnimatableLayerCommand]
    func makeSwiftUIModifier() -> (AnyView) -> AnyView
}

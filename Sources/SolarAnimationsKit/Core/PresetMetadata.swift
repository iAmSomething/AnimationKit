import SwiftUI
import UIKit

public struct PresetMetadata: Sendable, Identifiable {
    public let id: String
    public let category: String
    public let title: String
    public let description: String
    public let inputs: [ParameterInfo]
    public let outputs: [ParameterInfo]
    public let performance: PerformanceProfile
    public let defaultDuration: TimeInterval
    public let iconName: String?

    public init(
        id: String,
        category: String,
        title: String,
        description: String,
        inputs: [ParameterInfo],
        outputs: [ParameterInfo],
        performance: PerformanceProfile,
        defaultDuration: TimeInterval = 0.4,
        iconName: String? = nil
    ) {
        self.id = id
        self.category = category
        self.title = title
        self.description = description
        self.inputs = inputs
        self.outputs = outputs
        self.performance = performance
        self.defaultDuration = defaultDuration
        self.iconName = iconName
    }
}

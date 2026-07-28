import SwiftUI
import UIKit

public struct AnimationContext: Sendable {
    public let theme: AnimationTheme
    public let preset: AnimationPreset
    public let duration: TimeInterval
    public let delay: TimeInterval

    public var effectiveDuration: TimeInterval {
        duration
    }

    public init(
        theme: AnimationTheme,
        preset: AnimationPreset,
        duration: TimeInterval?,
        delay: TimeInterval = 0
    ) {
        self.theme = theme
        self.preset = preset
        self.duration = duration ?? theme.defaultDuration
        self.delay = delay
    }
}

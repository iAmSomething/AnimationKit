import SwiftUI
import UIKit

public struct ShakeAnimation: AnimationPresetProtocol {
    public var theme: AnimationTheme
    public var duration: TimeInterval = 0
    public var delay: TimeInterval = 0

    public init(theme: AnimationTheme) {
        self.theme = theme
    }

    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .easeInOut(duration: duration / 8)
    }

    public func makeUIKitAnimations() -> [AnimatableLayerCommand] {
        [.shake(intensity: theme.shakeIntensity, duration: duration)]
    }
}

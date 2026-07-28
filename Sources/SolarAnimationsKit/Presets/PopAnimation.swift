import SwiftUI
import UIKit

public struct PopAnimation: AnimationPresetProtocol {
    public var theme: AnimationTheme
    public var duration: TimeInterval = 0
    public var delay: TimeInterval = 0

    public init(theme: AnimationTheme) {
        self.theme = theme
    }

    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .interpolatingSpring(mass: 1, stiffness: 120, damping: theme.springDamping, initialVelocity: 0)
    }

    public func makeUIKitAnimations() -> [AnimatableLayerCommand] {
        [.scale(to: theme.popScale, duration: duration * 0.4),
         .scale(to: 1.0, duration: duration * 0.6)]
    }
}

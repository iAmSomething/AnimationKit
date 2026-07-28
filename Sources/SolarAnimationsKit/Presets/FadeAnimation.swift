import SwiftUI
import UIKit

public struct FadeAnimation: AnimationPresetProtocol {
    public var theme: AnimationTheme
    public var duration: TimeInterval = 0
    public var delay: TimeInterval = 0

    public init(theme: AnimationTheme) {
        self.theme = theme
    }

    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .easeOut(duration: duration)
    }

    public func makeUIKitAnimations() -> [AnimatableLayerCommand] {
        [.alpha(to: 1, duration: duration)]
    }
}

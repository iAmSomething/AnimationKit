import SwiftUI
import UIKit

public struct AnimationTheme: Sendable {
    public let id: String
    public let defaultDuration: TimeInterval
    public let springResponse: CGFloat
    public let springDamping: CGFloat
    public let timingCurve: AnimationTimingCurve
    public let accentColor: Color?
    public let shadowColor: Color?
    public let glowRadius: CGFloat
    public let shakeIntensity: CGFloat
    public let popScale: CGFloat
    public let emphasizeScale: CGFloat

    public init(
        id: String = "default",
        defaultDuration: TimeInterval = 0.4,
        springResponse: CGFloat = 0.35,
        springDamping: CGFloat = 0.7,
        timingCurve: AnimationTimingCurve = .easeOut,
        accentColor: Color? = .blue,
        shadowColor: Color? = .black.opacity(0.2),
        glowRadius: CGFloat = 8,
        shakeIntensity: CGFloat = 8,
        popScale: CGFloat = 1.12,
        emphasizeScale: CGFloat = 1.06
    ) {
        self.id = id
        self.defaultDuration = defaultDuration
        self.springResponse = springResponse
        self.springDamping = springDamping
        self.timingCurve = timingCurve
        self.accentColor = accentColor
        self.shadowColor = shadowColor
        self.glowRadius = glowRadius
        self.shakeIntensity = shakeIntensity
        self.popScale = popScale
        self.emphasizeScale = emphasizeScale
    }

    public static let `default` = AnimationTheme(id: "default")
    public static let darkAccent = AnimationTheme(
        id: "darkAccent",
        accentColor: .cyan,
        shadowColor: .white.opacity(0.25),
        glowRadius: 12,
        popScale: 1.15,
        emphasizeScale: 1.08
    )
    public static let minimal = AnimationTheme(
        id: "minimal",
        defaultDuration: 0.2,
        springResponse: 0.25,
        springDamping: 0.8,
        shakeIntensity: 4,
        popScale: 1.08,
        emphasizeScale: 1.03
    )
}

public enum AnimationTimingCurve: Sendable {
    case easeIn, easeOut, easeInOut, linear, spring
}

extension Color {
    var uiColor: UIColor? {
        // basic conversion for standard colors or fallback
        if self == .cyan { return .cyan }
        if self == .blue { return .systemBlue }
        return UIColor(self)
    }
}

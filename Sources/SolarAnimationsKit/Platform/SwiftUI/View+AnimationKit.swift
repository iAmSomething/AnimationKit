import SwiftUI

public extension View {
    func animationKit(
        _ preset: AnimationPreset,
        trigger: Bool = false,
        duration: TimeInterval? = nil,
        delay: TimeInterval = 0
    ) -> some View {
        self.modifier(
            AnimationKitModifier(
                preset: preset,
                trigger: trigger,
                duration: duration,
                delay: delay
            )
        )
    }

    func animationKitFade(visible: Bool) -> some View {
        self.opacity(visible ? 1 : 0)
            .animation(.easeOut(duration: AnimationKit.theme.defaultDuration), value: visible)
    }

    func animationKitSlide(visible: Bool, from edge: Edge) -> some View {
        let offset: CGFloat = visible ? 0 : (edge == .leading ? -200 : edge == .trailing ? 200 : edge == .top ? -200 : 200)
        return self.offset(
            x: edge == .leading || edge == .trailing ? offset : 0,
            y: edge == .top || edge == .bottom ? offset : 0
        )
        .animation(.easeOut(duration: AnimationKit.theme.defaultDuration), value: visible)
    }

    func animationKitPop(tapped: Bool) -> some View {
        self.scaleEffect(tapped ? AnimationKit.theme.popScale : 1)
            .animation(
                .interpolatingSpring(mass: 1, stiffness: 120, damping: AnimationKit.theme.springDamping, initialVelocity: 0),
                value: tapped
            )
    }

    func animationKitShake(visible: Bool, intensity: CGFloat? = nil) -> some View {
        let shakeOffset = visible ? 0 : (Int.random(in: -8...8) * Int(intensity ?? AnimationKit.theme.shakeIntensity))
        return self.offset(x: CGFloat(shakeOffset))
            .animation(.easeInOut(duration: 0.06), value: visible)
    }

    func animationKitGlow(visible: Bool, color: Color? = nil, radius: CGFloat? = nil) -> some View {
        let c = color ?? AnimationKit.theme.accentColor
        let r = radius ?? AnimationKit.theme.glowRadius
        return self.shadow(color: c ?? .clear, radius: visible ? r : 0)
            .animation(.easeOut(duration: AnimationKit.theme.defaultDuration), value: visible)
    }

    func animationKitSpin(degrees: Double = 360, duration: TimeInterval? = nil, infinite: Bool = true) -> some View {
        let dur = duration ?? AnimationKit.theme.defaultDuration
        return self.rotationEffect(.degrees(degrees))
            .animation(.linear(duration: dur).repeatForever(autoreverses: !infinite), value: UUID())
    }

    func animationKitEmphasize(tapped: Bool) -> some View {
        self.modifier(EmphasizeModifier(tapped: tapped))
    }

    func animationKitShimmer(isPlaying: Bool = true) -> some View {
        self.modifier(ShimmerModifier(isPlaying: isPlaying))
    }

    func animationKitConfetti(isTriggered: Bool, hapticsEnabled: Bool = false) -> some View {
        self.overlay(
            ConfettiViewRepresentable(isTriggered: isTriggered, hapticsEnabled: hapticsEnabled)
                .allowsHitTesting(false)
        )
    }

    func animationKitRollingNumber(from fromValue: Int = 0, to toValue: Int, duration: TimeInterval = 1.5, hapticsEnabled: Bool = false) -> some View {
        let anim = RollingNumberAnimation(from: fromValue, to: toValue, duration: duration, hapticsEnabled: hapticsEnabled)
        return AnyView(anim.makeSwiftUIModifier()(AnyView(self)))
    }

    func animationKitRipple(at origin: CGPoint = .zero, color: Color = .blue, hapticsEnabled: Bool = false) -> some View {
        self.modifier(
            RippleModifier(
                origin: origin,
                color: color,
                hapticsEnabled: hapticsEnabled
            )
        )
    }

    func animationKitTilt3D(maxAngle: Double = 15.0, perspective: CGFloat = 0.5, hapticsEnabled: Bool = false) -> some View {
        self.modifier(
            Tilt3DModifier(
                maxAngle: maxAngle,
                perspective: perspective,
                hapticsEnabled: hapticsEnabled
            )
        )
    }

    func animationKitTypewriter(text: String, characterDelay: TimeInterval = 0.05, hapticsEnabled: Bool = false) -> some View {
        self.modifier(
            TypewriterModifier(
                text: text,
                characterDelay: characterDelay,
                hapticsEnabled: hapticsEnabled
            )
        )
    }

    func animationKitGooey(blurRadius: CGFloat = 20, isActive: Bool = true) -> some View {
        self.modifier(
            GooeyModifier(blurRadius: blurRadius, isActive: isActive)
        )
    }

    func animationKitSparkle(isTriggered: Bool, color: Color = .yellow, hapticsEnabled: Bool = false) -> some View {
        self.overlay(
            SparkleViewRepresentable(isTriggered: isTriggered, color: UIColor(color), hapticsEnabled: hapticsEnabled)
                .allowsHitTesting(false)
        )
    }

    func animationKitMarquee(text: String, duration: TimeInterval = 5.0) -> some View {
        self.modifier(
            MarqueeModifier(text: text, duration: duration)
        )
    }

    func animationKitProgressiveBlur(blurStyle: UIBlurEffect.Style = .regular, direction: ProgressiveBlurAnimation.Direction = .bottomToTop) -> some View {
        self.overlay(
            ProgressiveBlurViewRepresentable(blurStyle: blurStyle, direction: direction)
                .allowsHitTesting(false)
        )
    }

    func animationKitPulse(isActive: Bool = true, color: Color = .blue, duration: TimeInterval = 2.0, scale: CGFloat = 1.5) -> some View {
        self.modifier(
            PulseModifier(isActive: isActive, color: color, duration: duration, scale: scale)
        )
    }

    func animationKitRubberband(tension: CGFloat = 0.5, hapticsEnabled: Bool = false) -> some View {
        self.modifier(
            RubberbandModifier(tension: tension, hapticsEnabled: hapticsEnabled)
        )
    }
}

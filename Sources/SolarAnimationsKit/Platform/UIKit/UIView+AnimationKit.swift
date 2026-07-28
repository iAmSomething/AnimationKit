import UIKit

@MainActor fileprivate var uiviewAnimationTransitionKey: UInt8 = 0


public extension UIView {
    @MainActor
    func animationKit(
        _ preset: AnimationPreset,
        duration: TimeInterval? = nil,
        delay: TimeInterval = 0,
        completion: (@Sendable () -> Void)? = nil
    ) {
        let token = AnimationToken()
        objc_setAssociatedObject(self, &uiviewAnimationTransitionKey, token, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        let animDuration = duration ?? AnimationKit.theme.defaultDuration

        switch preset {
        case .fade:
            alpha = 0
            UIView.animate(withDuration: animDuration, delay: delay,
                           options: [.curveEaseOut, .allowUserInteraction, .beginFromCurrentState],
                           animations: { self.alpha = 1 },
                           completion: { finished in
                if finished { completion?() }
                token.complete()
            })

        case .pop:
            transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animateKeyframes(withDuration: animDuration, delay: delay, options: [.calculationModeLinear], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                    self.transform = CGAffineTransform(scaleX: AnimationKit.theme.popScale, y: AnimationKit.theme.popScale)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                    self.transform = .identity
                }
            }, completion: { _ in
                token.complete()
                completion?()
            })

        case .shake:
            let center = self.center
            let intensity = AnimationKit.theme.shakeIntensity
            UIView.animateKeyframes(withDuration: animDuration, delay: delay, options: [.calculationModeLinear], animations: {
                for i in stride(from: 0.0, through: animDuration, by: 0.06) {
                    let offset = ((Int(i / 0.06) % 2) == 0) ? -intensity : intensity
                    UIView.addKeyframe(withRelativeStartTime: i / animDuration, relativeDuration: 0.06) {
                        self.center.x = center.x + offset
                    }
                }
            }, completion: { _ in
                MainActor.assumeIsolated {
                    UIView.animate(withDuration: 0.1) { self.center = center }
                    token.complete()
                    completion?()
                }
            })

        case .glow:
            layer.shadowColor = AnimationKit.theme.accentColor?.uiColor?.cgColor ?? UIColor.black.cgColor
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
            layer.shadowOffset = .zero
            UIView.animate(withDuration: animDuration * 0.4, delay: delay,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                self.layer.shadowOpacity = 0.3
                self.layer.shadowRadius = AnimationKit.theme.glowRadius
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { _ in
                UIView.animate(withDuration: animDuration * 0.3, delay: 0,
                               options: [.curveEaseOut, .allowUserInteraction],
                               animations: {
                    self.layer.shadowOpacity = 0
                    self.layer.shadowRadius = 0
                    self.transform = .identity
                }) { _ in
                    token.complete()
                    completion?()
                }
            }

        case .spin(let degrees):
            UIView.animate(withDuration: animDuration, delay: delay,
                           options: [.curveLinear, .allowUserInteraction],
                           animations: {
                self.transform = self.transform.rotated(by: CGFloat(degrees * .pi / 180))
            }, completion: { _ in
                token.complete()
                completion?()
            })

        case .emphasize:
            layer.shadowColor = AnimationKit.theme.shadowColor?.uiColor?.cgColor ?? UIColor.black.cgColor
            layer.shadowOpacity = 0
            transform = .identity
            UIView.animate(withDuration: animDuration, delay: delay,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                self.transform = CGAffineTransform(scaleX: AnimationKit.theme.emphasizeScale, y: AnimationKit.theme.emphasizeScale)
                self.layer.shadowOpacity = 0.2
                self.layer.shadowRadius = AnimationKit.theme.glowRadius * 0.5
                self.layer.shadowOffset = CGSize(width: 0, height: 3)
            }) { _ in
                UIView.animate(withDuration: animDuration * 0.5, delay: 0,
                               options: [.curveEaseOut, .allowUserInteraction],
                               animations: {
                    self.transform = .identity
                    self.layer.shadowOpacity = 0
                }) { _ in
                    token.complete()
                    completion?()
                }
            }

        case .shimmer:
            let anim = ShimmerAnimation(isPlaying: true)
            if let command = anim.makeUIKitCommands().first {
                command.apply(on: self.layer, theme: .default)
            }
            completion?()
            token.complete()

        case .confetti:
            let anim = ConfettiAnimation(isTriggered: true)
            if let command = anim.makeUIKitCommands().first {
                command.apply(on: self.layer, theme: .default)
            }
            completion?()
            token.complete()

        case .sparkle(let isTriggered, let color, let hapticsEnabled):
            let anim = SparkleAnimation(isTriggered: isTriggered, color: color, hapticsEnabled: hapticsEnabled)
            if let command = anim.makeUIKitCommands().first {
                command.apply(on: self.layer, theme: .default)
            }
            completion?()
            token.complete()

        case .marquee(let text, let duration):
            let anim = MarqueeAnimation(text: text, duration: duration)
            if let command = anim.makeUIKitCommands().first {
                command.apply(on: self.layer, theme: .default)
            }
            completion?()
            token.complete()

        case .progressiveBlur(let blurStyle, let direction):
            let anim = ProgressiveBlurAnimation(blurStyle: blurStyle, direction: direction)
            if let command = anim.makeUIKitCommands().first {
                command.apply(on: self.layer, theme: .default)
            }
            completion?()
            token.complete()

        case .pulse(let isActive, let color, let duration, let scale):
            let anim = PulseAnimation(isActive: isActive, color: color, duration: duration, scale: scale)
            if let command = anim.makeUIKitCommands().first {
                command.apply(on: self.layer, theme: .default)
            }
            completion?()
            token.complete()

        case .rubberband(let tension, let hapticsEnabled):
            let anim = RubberbandAnimation(tension: tension, hapticsEnabled: hapticsEnabled)
            if let command = anim.makeUIKitCommands().first {
                command.apply(on: self.layer, theme: .default)
            }
            completion?()
            token.complete()

        default:
            completion?()
            token.complete()
        }
    }

    @MainActor
    func animationKitCancel() {
        if let token = objc_getAssociatedObject(self, &uiviewAnimationTransitionKey) as? AnimationToken {
            AnimationKit.cancel(token)
        }
    }

    @MainActor
    func animationKitPop(duration: TimeInterval? = nil) {
        let dur = duration ?? AnimationKit.theme.defaultDuration
        UIView.animateKeyframes(withDuration: dur, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.transform = CGAffineTransform(scaleX: AnimationKit.theme.popScale, y: AnimationKit.theme.popScale)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                self.transform = .identity
            }
        })
    }

    @MainActor
    func animationKitShake(intensity: CGFloat? = nil, duration: TimeInterval? = nil) {
        let int = intensity ?? AnimationKit.theme.shakeIntensity
        let dur = duration ?? AnimationKit.theme.defaultDuration
        let center = self.center
        UIView.animateKeyframes(withDuration: dur, delay: 0, options: [.calculationModeLinear], animations: {
            for i in stride(from: 0.0, through: dur, by: 0.06) {
                let offset = ((Int(i / 0.06) % 2) == 0) ? -int : int
                UIView.addKeyframe(withRelativeStartTime: i / dur, relativeDuration: 0.06) {
                    self.center.x = center.x + offset
                }
            }
        }, completion: { _ in
            MainActor.assumeIsolated {
                UIView.animate(withDuration: 0.1) { self.center = center }
            }
        })
    }

    @MainActor
    func animationKitEmphasize(duration: TimeInterval? = nil) {
        let dur = duration ?? AnimationKit.theme.defaultDuration
        UIView.animate(withDuration: dur * 0.15, delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
            self.transform = CGAffineTransform(scaleX: AnimationKit.theme.emphasizeScale, y: AnimationKit.theme.emphasizeScale)
            self.layer.shadowColor = AnimationKit.theme.shadowColor?.uiColor?.cgColor ?? UIColor.black.cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowRadius = AnimationKit.theme.glowRadius
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
        }, completion: { _ in
            UIView.animate(withDuration: dur * 0.2, delay: 0,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                self.transform = .identity
                self.layer.shadowOpacity = 0
            })
        })
    }

    @MainActor
    func animationKitGlow(color: UIColor? = nil, radius: CGFloat? = nil, duration: TimeInterval? = nil) {
        let c = color ?? (AnimationKit.theme.accentColor?.uiColor ?? .systemBlue)
        let r = radius ?? AnimationKit.theme.glowRadius
        let dur = duration ?? AnimationKit.theme.defaultDuration
        layer.shadowColor = c.cgColor
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.shadowOffset = .zero
        UIView.animate(withDuration: dur * 0.4, delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = r
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: dur * 0.3, delay: 0,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.transform = .identity
            })
        }
    }

    @MainActor
    func animationKitSpin(degrees: Double = 360, duration: TimeInterval? = nil, completion: (@Sendable () -> Void)? = nil) {
        let dur = duration ?? AnimationKit.theme.defaultDuration
        UIView.animate(withDuration: dur, delay: 0,
                       options: [.curveLinear, .allowUserInteraction],
                       animations: {
            self.transform = self.transform.rotated(by: CGFloat(degrees * .pi / 180))
        }, completion: { _ in completion?() })
    }

    @MainActor
    func animationKitSlide(in from: Edge, duration: TimeInterval? = nil) {
        let dur = duration ?? AnimationKit.theme.defaultDuration
        switch from {
        case .top: frame.origin.y -= bounds.height
        case .bottom: frame.origin.y += bounds.height
        case .leading: frame.origin.x -= bounds.width
        case .trailing: frame.origin.x += bounds.width
        }
        UIView.animate(withDuration: dur, delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
            self.frame.origin = self.superview?.convert(self.frame.origin, to: nil) ?? self.frame.origin
        })
    }

    @MainActor
    func animationKitShimmer(isPlaying: Bool = true) {
        let anim = ShimmerAnimation(isPlaying: isPlaying)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitConfetti(hapticsEnabled: Bool = false) {
        let anim = ConfettiAnimation(isTriggered: true, hapticsEnabled: hapticsEnabled)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitRollingNumber(from fromValue: Int = 0, to toValue: Int, duration: TimeInterval = 1.5, hapticsEnabled: Bool = false) {
        let anim = RollingNumberAnimation(from: fromValue, to: toValue, duration: duration, hapticsEnabled: hapticsEnabled)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitRipple(at origin: CGPoint = .zero, color: UIColor = .systemBlue, hapticsEnabled: Bool = false) {
        let anim = RippleAnimation(origin: origin, color: color, hapticsEnabled: hapticsEnabled)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitTilt3D(maxAngle: Double = 15.0, perspective: CGFloat = 0.5, hapticsEnabled: Bool = false) {
        let anim = Tilt3DAnimation(maxAngle: maxAngle, perspective: perspective, hapticsEnabled: hapticsEnabled)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitTypewriter(text: String, characterDelay: TimeInterval = 0.05, hapticsEnabled: Bool = false) {
        let anim = TypewriterAnimation(text: text, characterDelay: characterDelay, hapticsEnabled: hapticsEnabled)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitGooey(blurRadius: CGFloat = 20, isActive: Bool = true) {
        let anim = GooeyAnimation(blurRadius: blurRadius, isActive: isActive)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitSparkle(isTriggered: Bool, color: UIColor = .systemYellow, hapticsEnabled: Bool = false) {
        let anim = SparkleAnimation(isTriggered: isTriggered, color: color, hapticsEnabled: hapticsEnabled)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitMarquee(text: String, duration: TimeInterval = 5.0) {
        let anim = MarqueeAnimation(text: text, duration: duration)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitProgressiveBlur(blurStyle: UIBlurEffect.Style = .regular, direction: ProgressiveBlurAnimation.Direction = .bottomToTop) {
        let anim = ProgressiveBlurAnimation(blurStyle: blurStyle, direction: direction)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitPulse(isActive: Bool = true, color: UIColor = .systemBlue, duration: TimeInterval = 2.0, scale: CGFloat = 1.5) {
        let anim = PulseAnimation(isActive: isActive, color: color, duration: duration, scale: scale)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }

    @MainActor
    func animationKitRubberband(tension: CGFloat = 0.5, hapticsEnabled: Bool = false) {
        let anim = RubberbandAnimation(tension: tension, hapticsEnabled: hapticsEnabled)
        if let command = anim.makeUIKitCommands().first {
            command.apply(on: self.layer, theme: .default)
        }
    }
}

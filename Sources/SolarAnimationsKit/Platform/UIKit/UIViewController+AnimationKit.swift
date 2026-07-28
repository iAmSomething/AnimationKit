import UIKit

@MainActor fileprivate var animationTransitionKey: UInt8 = 0

public extension UIViewController {
    @MainActor
    func animationKit(
        _ preset: AnimationPreset,
        on view: UIView? = nil,
        duration: TimeInterval? = nil,
        delay: TimeInterval = 0,
        completion: (@Sendable () -> Void)? = nil
    ) {
        let target = view ?? self.view
        target?.animationKit(preset, duration: duration, delay: delay, completion: completion)
    }

    @MainActor
    func animationKitModalPresent(_ preset: AnimationPreset, duration: TimeInterval? = nil) {
        modalPresentationStyle = .custom
        let delegate = AnimationTransitioningDelegate(preset: preset, duration: duration)
        objc_setAssociatedObject(self, &animationTransitionKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        transitioningDelegate = delegate
    }
}



@MainActor
private class AnimationTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let preset: AnimationPreset
    let duration: TimeInterval

    init(preset: AnimationPreset, duration: TimeInterval? = nil) {
        self.preset = preset
        self.duration = duration ?? AnimationKit.theme.defaultDuration
    }

    func animationController(forPresented presented: UIViewController,
                            presenting: UIViewController,
                            source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AnimationTransitionAnimator(preset: preset, duration: duration, isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AnimationTransitionAnimator(preset: preset, duration: duration, isPresenting: false)
    }
}

private class AnimationTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let preset: AnimationPreset
    let duration: TimeInterval
    let isPresenting: Bool

    init(preset: AnimationPreset, duration: TimeInterval, isPresenting: Bool) {
        self.preset = preset
        self.duration = duration
        self.isPresenting = isPresenting
    }

    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let toVC = ctx.viewController(forKey: .to)
        let fromVC = ctx.viewController(forKey: .from)
        let toView = ctx.view(forKey: .to) ?? toVC?.view
        let fromView = ctx.view(forKey: .from) ?? fromVC?.view
        let container = ctx.containerView

        if let toV = toView {
            if isPresenting {
                container.addSubview(toV)
            } else {
                container.addSubview(toV)
                container.sendSubviewToBack(toV)
            }
        }

        switch preset {
        case .fade:
            toView?.alpha = isPresenting ? 0 : 1
            fromView?.alpha = isPresenting ? 1 : 0
        case .slide(let direction, _):
            let offset: CGFloat = isPresenting ? (direction == .enter ? (toView?.bounds.width ?? 0) : -(toView?.bounds.width ?? 0)) : 0
            toView?.frame.origin.x += offset
        default:
            break
        }

        UIView.animate(withDuration: duration, delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
            switch self.preset {
            case .fade:
                toView?.alpha = self.isPresenting ? 1 : 0
                fromView?.alpha = self.isPresenting ? 0 : 1
            case .slide(let direction, _):
                let offset = self.isPresenting ? (direction == .enter ? (toView?.bounds.width ?? 0) : -(toView?.bounds.width ?? 0)) : 0
                toView?.frame.origin.x -= offset
            default:
                break
            }
        }) { _ in
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }
}

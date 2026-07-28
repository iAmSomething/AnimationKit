import UIKit

public enum AnimatableLayerCommand: Sendable {
    case alpha(to: CGFloat, duration: TimeInterval)
    case scale(to: CGFloat, duration: TimeInterval)
    case translate(x: CGFloat, y: CGFloat, duration: TimeInterval)
    case rotate(to: CGFloat, duration: TimeInterval)
    case shake(intensity: CGFloat, duration: TimeInterval)
    case wiggle(intensity: CGFloat, duration: TimeInterval, frequency: CGFloat)
    case glow(color: UIColor, radius: CGFloat, duration: TimeInterval)
    case custom(@MainActor @Sendable (CALayer, TimeInterval) -> Void)

    @MainActor
    public func apply(on layer: CALayer, theme: AnimationTheme) {
        switch self {
        case .alpha(let to, _): layer.opacity = Float(to)
        case .scale(let to, _): layer.transform = CATransform3DMakeScale(to, to, 1)
        case .translate(let x, let y, _): layer.position = CGPoint(x: layer.position.x + x, y: layer.position.y + y)
        case .rotate(let to, _): layer.transform = CATransform3DRotate(layer.transform, to, 0, 0, 1)
        case .shake, .wiggle: break // handled by UIView.animateKeyframes
        case .glow(let color, let radius, _):
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = 0.3
            layer.shadowRadius = radius
        case .custom(let block): block(layer, 0)
        }
    }
}

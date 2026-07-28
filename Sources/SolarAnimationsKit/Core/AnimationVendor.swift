import SwiftUI
import UIKit

public protocol AnimationKitHost {}
extension UIView: AnimationKitHost {}
extension UIViewController: AnimationKitHost {}

public protocol AnimatableViewProtocol: AnimationKitHost {
    func animate(with preset: AnimationPreset,
                 context: AnimationContext,
                 token: AnimationToken,
                 completion: (() -> Void)?)
}

public protocol AnimatableViewControllerProtocol: AnimationKitHost {
    func animate(with preset: AnimationPreset,
                 context: AnimationContext,
                 token: AnimationToken,
                 completion: (() -> Void)?)
}

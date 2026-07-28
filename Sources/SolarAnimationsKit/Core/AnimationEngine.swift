import SwiftUI
import UIKit

public struct AnimationEngine {
    private let context: AnimationContext

    public init(context: AnimationContext) {
        self.context = context
    }

    public func execute(
        on target: any AnimationKitHost,
        completion: (() -> Void)? = nil
    ) -> AnimationToken {
        let token = AnimationToken()
        let preset = context.preset

        if let view = target as? AnimatableViewProtocol {
            view.animate(with: preset, context: context, token: token, completion: completion)
        } else if let vc = target as? AnimatableViewControllerProtocol {
            vc.animate(with: preset, context: context, token: token, completion: completion)
        } else {
            completion?()
        }

        return token
    }
}

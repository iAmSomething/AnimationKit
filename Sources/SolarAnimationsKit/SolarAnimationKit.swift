import SwiftUI
import UIKit

@MainActor
public enum AnimationKit {
    public static var theme: AnimationTheme = .default

    public static var catalog: AnimationCatalog { .shared }

    @discardableResult
    public static func animate(
        _ preset: AnimationPreset,
        on target: any AnimationKitHost,
        duration: TimeInterval? = nil,
        delay: TimeInterval = 0,
        completion: (() -> Void)? = nil
    ) -> AnimationToken {
        let ctx = AnimationContext(theme: theme, preset: preset, duration: duration, delay: delay)
        let engine = AnimationEngine(context: ctx)
        return engine.execute(on: target, completion: completion)
    }

    @discardableResult
    public static func animate(id: String,
                               on target: any AnimationKitHost,
                               duration: TimeInterval? = nil,
                               completion: (() -> Void)? = nil) -> AnimationToken {
        guard let _ = AnimationCatalog.shared.get(by: id) else {
            fatalError("Unknown animation ID: \(id)")
        }
        // Custom animation execution logic here
        return AnimationToken()
    }

    public static func cancel(_ token: AnimationToken) {
        token.cancel()
    }

    public static func register(_ animation: any SolarAnimatable) {
        AnimationCatalog.shared.register(animation)
    }

    public static func sequence() -> AnimationSequenceBuilder {
        AnimationSequenceBuilder()
    }
}

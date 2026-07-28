import Foundation

public struct AnimationSequenceBuilder {
    private var steps: [SequenceStep] = []

    internal init() {}

    public func append(_ preset: AnimationPreset, duration: TimeInterval? = nil) -> Self {
        var copy = self
        copy.steps.append(.serial(preset: preset, duration: duration))
        return copy
    }

    public func appendParallel(_ preset: AnimationPreset, duration: TimeInterval? = nil) -> Self {
        var copy = self
        copy.steps.append(.parallel(preset: preset, duration: duration))
        return copy
    }

    public func append(if condition: Bool, _ preset: AnimationPreset, duration: TimeInterval? = nil) -> Self {
        if condition {
            var copy = self
            copy.steps.append(.serial(preset: preset, duration: duration))
            return copy
        }
        return self
    }

    @discardableResult
    @MainActor
    public func run(on target: any AnimationKitHost, theme: AnimationTheme = AnimationKit.theme) -> [AnimationToken] {
        steps.map { step in
            switch step {
            case .serial(let preset, let duration):
                return AnimationKit.animate(preset, on: target, duration: duration)
            case .parallel(let preset, let duration):
                return AnimationKit.animate(preset, on: target, duration: duration)
            }
        }
    }
}

extension AnimationSequenceBuilder {
    public enum SequenceStep {
        case serial(preset: AnimationPreset, duration: TimeInterval?)
        case parallel(preset: AnimationPreset, duration: TimeInterval?)
    }
}

import Foundation

public final class AnimationCatalog: @unchecked Sendable {
    public static let shared = AnimationCatalog()

    private var presets: [String: any AnimationPresetProtocol] = [:]
    private var animations: [String: any SolarAnimatable] = [:]
    private var lock = DispatchSemaphore(value: 1)

    private init() {}

    // MARK: - Preset Registration

    public func registerPreset(name: String, preset: any AnimationPresetProtocol) {
        lock.wait()
        defer { lock.signal() }
        presets[name] = preset
    }

    public func getPreset(name: String) -> (any AnimationPresetProtocol)? {
        lock.wait()
        defer { lock.signal() }
        return presets[name]
    }

    // MARK: - Animation Registration

    public func register(_ animation: any SolarAnimatable) {
        lock.wait()
        defer { lock.signal() }
        animations[animation.id] = animation
    }

    public func unregister(id: String) {
        lock.wait()
        defer { lock.signal() }
        animations.removeValue(forKey: id)
    }

    public func get(by id: String) -> (any SolarAnimatable)? {
        lock.wait()
        defer { lock.signal() }
        return animations[id]
    }

    public func getAll() -> [any SolarAnimatable] {
        lock.wait()
        defer { lock.signal() }
        return Array(animations.values)
    }

    public func getAll(in category: String) -> [any SolarAnimatable] {
        lock.wait()
        defer { lock.signal() }
        return animations.values.filter { $0.category == category }
    }
}

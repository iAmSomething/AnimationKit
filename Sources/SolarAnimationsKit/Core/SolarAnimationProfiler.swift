import Foundation
import UIKit

#if DEBUG
@MainActor
public enum SolarAnimationProfiler {
    private static var isEnabled: Bool = false
    private static var metrics: [String: [AnimationMetric]] = [:]

    public struct AnimationMetric: Sendable {
        public let presetName: String
        public let startTime: TimeInterval
        public let duration: TimeInterval
        public let framesDropped: Int
        public let memoryEstimate: String
        public let performanceClass: PerformanceProfile.ComplexityClass

        public init(presetName: String,
                    startTime: TimeInterval,
                    duration: TimeInterval,
                    framesDropped: Int,
                    memoryEstimate: String,
                    performanceClass: PerformanceProfile.ComplexityClass) {
            self.presetName = presetName
            self.startTime = startTime
            self.duration = duration
            self.framesDropped = framesDropped
            self.memoryEstimate = memoryEstimate
            self.performanceClass = performanceClass
        }
    }

    public static func begin(presetName: String, profile: PerformanceProfile) {
        guard isEnabled else { return }
        let now = Date().timeIntervalSince1970
        let metric = AnimationMetric(
            presetName: presetName,
            startTime: now,
            duration: 0,
            framesDropped: 0,
            memoryEstimate: profile.estimatedMemoryFootprint,
            performanceClass: profile.classType
        )
        metrics[presetName, default: []].append(metric)
    }

    public static func end(presetName: String) {
        guard isEnabled else { return }
        if let metricsForPreset = metrics[presetName], !metricsForPreset.isEmpty {
            let last = metricsForPreset.last!
            let updated = AnimationMetric(
                presetName: last.presetName,
                startTime: last.startTime,
                duration: Date().timeIntervalSince1970 - last.startTime,
                framesDropped: last.framesDropped,
                memoryEstimate: last.memoryEstimate,
                performanceClass: last.performanceClass
            )
            metrics[presetName]?.removeLast()
            metrics[presetName]?.append(updated)
        }
    }

    public static func report() {
        guard isEnabled else { return }
        print("=== SolarAnimationKit Performance Report ===")
        for (name, metrics) in metrics {
            if let last = metrics.last {
                print("[\(name)] Class: \(last.performanceClass.rawValue) | Duration: \(String(format: "%.3f", last.duration))s | Est: \(last.memoryEstimate)")
            }
        }
        print("=============================================")
    }

    public static func checkComplexity(of preset: AnimationPreset) -> PerformanceProfile.ComplexityClass {
        preset.quickView.performance.classType
    }
}
#endif

import Foundation

public struct PerformanceProfile: Sendable {
    public enum ComplexityClass: String, Sendable {
        case gpuOptimized = "O(1)-GPU"
        case cpuBound = "O(1)-CPU"
        case linearPerFrame = "O(n)-Frame"
        case layoutInvalidating = "O(n)-Layout"
        case offscreenRisk = "O(1)-Offscreen"
    }

    public let classType: ComplexityClass
    public let estimatedMemoryFootprint: String
    public let mainThreadBlocking: Bool
    public let needsRasterization: Bool
    public let recommendedMaxInstances: Int
    public let potentialLeakRisk: Bool

    public init(
        classType: ComplexityClass,
        estimatedMemoryFootprint: String = "Low (<1KB)",
        mainThreadBlocking: Bool = false,
        needsRasterization: Bool = false,
        recommendedMaxInstances: Int = 50,
        potentialLeakRisk: Bool = false
    ) {
        self.classType = classType
        self.estimatedMemoryFootprint = estimatedMemoryFootprint
        self.mainThreadBlocking = mainThreadBlocking
        self.needsRasterization = needsRasterization
        self.recommendedMaxInstances = recommendedMaxInstances
        self.potentialLeakRisk = potentialLeakRisk
    }

    public var performanceLabel: String {
        switch classType {
        case .gpuOptimized: return "🚀 GPU Optimized"
        case .cpuBound: return "⚡ CPU Bound"
        case .linearPerFrame: return "⚠️ Linear Per Frame"
        case .layoutInvalidating: return "🛑 Layout Invalidating"
        case .offscreenRisk: return "🔥 Offscreen Risk"
        }
    }

    public var safetyWarning: String? {
        switch (classType, recommendedMaxInstances) {
        case (.offscreenRisk, let max) where max < 20:
            return "오프스크린 렌더링 위험. 동시 인스턴스 수를 제한하세요."
        case (.linearPerFrame, let max) where max < 15:
            return "많은 뷰에 동시 적용 시 프레임 드랍 가능."
        case (.layoutInvalidating, _):
            return "레이아웃 패스 무효화. 스크롤 뷰 내부 비추천."
        default:
            return nil
        }
    }
}

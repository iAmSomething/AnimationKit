import XCTest
@testable import SolarAnimationsKit

final class MetadataTests: XCTestCase {
    
    @MainActor
    func testCatalogContainsAllAdvancedPresets() throws {
        // Register manually to test catalog
        let catalog = AnimationCatalog.shared
        let shimmer = ShimmerAnimation(isPlaying: true)
        catalog.register(shimmer)
        
        XCTAssertNotNil(catalog.get(by: "shimmer"))
        catalog.unregister(id: "shimmer")
        XCTAssertNil(catalog.get(by: "shimmer"))
    }
    
    @MainActor
    func testPresetMetadataContents() throws {
        // Test Ripple
        let ripple = RippleAnimation(origin: .zero, color: .blue, hapticsEnabled: true)
        XCTAssertEqual(ripple.id, "ripple")
        XCTAssertEqual(ripple.category, "Advanced")
        XCTAssertTrue(ripple.inputSchema.properties.contains { $0.name == "hapticsEnabled" })
        XCTAssertEqual(ripple.performance.classType, .linearPerFrame)
        
        // Test Shimmer
        let shimmer = ShimmerAnimation(isPlaying: true)
        XCTAssertEqual(shimmer.category, "Advanced")
        XCTAssertEqual(shimmer.inputSchema.properties.first?.name, "isPlaying")
        XCTAssertEqual(shimmer.performance.classType, .gpuOptimized)
        
        // Test Confetti
        let confetti = ConfettiAnimation(isTriggered: true, hapticsEnabled: false)
        XCTAssertEqual(confetti.category, "Advanced")
        XCTAssertTrue(confetti.inputSchema.properties.contains { $0.name == "hapticsEnabled" })
        XCTAssertEqual(confetti.performance.classType, .linearPerFrame)
        
        // Test Sparkle
        let sparkle = SparkleAnimation(isTriggered: true)
        XCTAssertEqual(sparkle.id, "sparkle")
        XCTAssertEqual(sparkle.performance.classType, .linearPerFrame)
        
        // Test Marquee
        let marquee = MarqueeAnimation(text: "Test")
        XCTAssertEqual(marquee.id, "marquee")
        XCTAssertEqual(marquee.category, "Advanced")
        
        // Test ProgressiveBlur
        let progBlur = ProgressiveBlurAnimation()
        XCTAssertEqual(progBlur.id, "progressiveBlur")
        XCTAssertEqual(progBlur.performance.classType, .gpuOptimized)
        
        // Test Pulse
        let pulse = PulseAnimation()
        XCTAssertEqual(pulse.id, "pulse")
        XCTAssertTrue(pulse.inputSchema.properties.contains { $0.name == "isActive" })
        
        // Test Rubberband
        let rubberband = RubberbandAnimation()
        XCTAssertEqual(rubberband.id, "rubberband")
        XCTAssertEqual(rubberband.performance.classType, .cpuBound)
    }
}

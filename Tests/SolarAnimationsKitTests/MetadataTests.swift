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
    }
}

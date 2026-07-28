import XCTest
@testable import SolarAnimationsKit

final class SolarAnimationsKitTests: XCTestCase {
    
    @MainActor
    func testEnumQuickViewMetadata() throws {
        let fadeMetadata = AnimationPreset.fade.quickView
        XCTAssertEqual(fadeMetadata.id, "fade")
        XCTAssertEqual(fadeMetadata.performance.classType, .gpuOptimized)
    }
}

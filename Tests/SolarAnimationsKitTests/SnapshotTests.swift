import XCTest
import SnapshotTesting
import SwiftUI
@testable import SolarAnimationsKit

final class SnapshotTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // isRecording = true // Set to true to record new snapshots
    }
    
    @MainActor
    func testFadeInitialState() {
        let view = Rectangle()
            .fill(Color.blue)
            .frame(width: 100, height: 100)
            .animationKit(.fade)
        
        let vc = UIHostingController(rootView: view)
        vc.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        assertSnapshot(of: vc, as: .image(size: CGSize(width: 100, height: 100)))
    }
    
    @MainActor
    func testGooeyInitialState() {
        let view = ZStack {
            Circle().fill(Color.red).frame(width: 50, height: 50).offset(x: -20)
            Circle().fill(Color.red).frame(width: 50, height: 50).offset(x: 20)
        }
        .frame(width: 200, height: 100)
        .animationKitGooey(blurRadius: 10)
        
        let vc = UIHostingController(rootView: view)
        vc.view.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        
        assertSnapshot(of: vc, as: .image(size: CGSize(width: 200, height: 100)))
    }
    
    @MainActor
    func testTilt3DInitialState() {
        let view = RoundedRectangle(cornerRadius: 12)
            .fill(Color.green)
            .frame(width: 150, height: 200)
            .animationKitTilt3D(maxAngle: 15.0)
        
        let vc = UIHostingController(rootView: view)
        vc.view.frame = CGRect(x: 0, y: 0, width: 200, height: 250)
        
        assertSnapshot(of: vc, as: .image(size: CGSize(width: 200, height: 250)))
    }
}

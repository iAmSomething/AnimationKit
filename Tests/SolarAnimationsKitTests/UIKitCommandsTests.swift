import XCTest
@testable import SolarAnimationsKit

final class UIKitCommandsTests: XCTestCase {
    
    @MainActor
    func testFadeCommands() throws {
        var fade = FadeAnimation(theme: .default)
        fade.duration = 1.0
        let commands = fade.makeUIKitAnimations()
        XCTAssertEqual(commands.count, 1)
        
        if case .alpha(let alpha, let duration) = commands.first {
            XCTAssertEqual(alpha, 1.0)
            XCTAssertEqual(duration, 1.0)
        } else {
            XCTFail("Expected .alpha command")
        }
    }
    
    @MainActor
    func testPopCommands() throws {
        var pop = PopAnimation(theme: .default)
        pop.duration = 1.0
        let commands = pop.makeUIKitAnimations()
        XCTAssertEqual(commands.count, 2)
        
        if case .scale(let scale, let duration) = commands.first {
            XCTAssertEqual(scale, AnimationTheme.default.popScale)
            XCTAssertEqual(duration, 0.4)
        } else {
            XCTFail("Expected .scale command for first element")
        }
    }
    
    @MainActor
    func testConfettiCommands() throws {
        let confetti = ConfettiAnimation(isTriggered: true)
        let commands = confetti.makeUIKitCommands()
        XCTAssertEqual(commands.count, 1)
        
        if case .custom = commands.first {
            // Success
        } else {
            XCTFail("Expected .custom command")
        }
    }
    
    @MainActor
    func testTypewriterCommands() throws {
        let tw = TypewriterAnimation(text: "Hello", characterDelay: 0.1, hapticsEnabled: true)
        let commands = tw.makeUIKitCommands()
        XCTAssertEqual(commands.count, 1)
        
        if case .custom = commands.first {
            // Success
        } else {
            XCTFail("Expected .custom command")
        }
    }
}

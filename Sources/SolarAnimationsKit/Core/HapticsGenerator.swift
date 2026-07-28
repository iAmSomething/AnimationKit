import UIKit
import SwiftUI

/// 햅틱 피드백 유틸리티
///
/// 애플리케이션 내 애니메이션 트리거 시 시스템 햅틱 엔진을 통해 물리적인 피드백을 전달합니다.
@MainActor
public struct HapticsGenerator: Sendable {
    public static func triggerImpact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    public static func triggerNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    public static func triggerSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}

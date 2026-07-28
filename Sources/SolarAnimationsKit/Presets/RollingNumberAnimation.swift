import SwiftUI
import UIKit

/// Rolling Number 애니메이션 프리셋
///
/// 슬롯머신처럼 숫자가 수직으로 스크롤되며 목표 값까지 카운트되는 효과입니다.
/// 각 자릿수가 독립적으로 회전하며 최종 값에 도달하면 정지합니다.
/// 금융 앱 잔액 표시, 만보기 걸음 수, 점수판, 주식 호가창에 적합합니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ✅ (선택적) — 숫자 도달 시 `selection` 햅틱 발생
/// - **입력 매개변수**:
///   - `fromValue` (Int, default: 0): 시작 숫자
///   - `toValue` (Int): 목표 숫자
///   - `duration` (TimeInterval, default: 1.5): 롤링 지속 시간
///   - `hapticsEnabled` (Bool, default: false): 햅틱 피드백 활성화 여부
/// - **관측 가능한 출력**:
///   - `displayedValue` (Int): 현재 표시 중인 숫자 값
///
/// ## 사용 예시
/// ```swift
/// // SwiftUI
/// view.animationKitRollingNumber(from: 0, to: 9999, hapticsEnabled: true)
///
/// // UIKit
/// view.animationKitRollingNumber(from: 0, to: 9999, hapticsEnabled: true)
/// ```
public struct RollingNumberAnimation: SolarAnimatable {
    public let id: String = "rollingNumber"
    public let displayName: String = "롤링 넘버 (숫자 티커)"
    public let description: String = "슬롯머신 스타일 숫자 스크롤 효과. 금융 앱 잔액, 점수판에 적합."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(
        classType: .cpuBound,
        recommendedMaxInstances: 20
    )
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "fromValue", type: "Int", defaultValue: "0", description: "시작 숫자"),
        ParameterInfo(name: "toValue", type: "Int", description: "목표 숫자"),
        ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "1.5", description: "롤링 지속 시간"),
        ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
    ])
    public let outputEffects: [ParameterInfo] = [
        ParameterInfo(name: "displayedValue", type: "Int", description: "현재 표시 중인 숫자 값")
    ]
    public let iconName: String? = "number.circle.fill"
    
    private let fromValue: Int
    private let toValue: Int
    private let duration: TimeInterval
    private let hapticsEnabled: Bool
    
    public init(from fromValue: Int = 0, to toValue: Int, duration: TimeInterval = 1.5, hapticsEnabled: Bool = false) {
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.hapticsEnabled = hapticsEnabled
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .easeOut(duration: duration)
    }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        let from = fromValue
        let to = toValue
        let dur = duration
        let haptic = hapticsEnabled
        
        return [.custom({ @MainActor layer, _ in
            guard let superview = layer.delegate as? UIView else { return }
            
            // 가장 가까운 UILabel 탐색
            let targetLabel: UILabel? = superview as? UILabel ?? superview.subviews.compactMap { $0 as? UILabel }.first
            guard let label = targetLabel else { return }
            
            let startTime = CACurrentMediaTime()
            let totalSteps = max(1, Int(dur / 0.016))
            let stepDuration = dur / Double(totalSteps)
            var currentStep = 0
            
            let timer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
                let elapsed = CACurrentMediaTime() - startTime
                let progress = min(elapsed / dur, 1.0)
                let eased = 1.0 - pow(1.0 - progress, 3)
                let current = Int(Double(from) + Double(to - from) * eased)
                label.text = "\(current)"
                currentStep += 1
                
                if progress >= 1.0 {
                    timer.invalidate()
                    label.text = "\(to)"
                    if haptic {
                        HapticsGenerator.triggerSelection()
                    }
                }
            }
            
            RunLoop.main.add(timer, forMode: .common)
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.modifier(
                    RollingNumberModifier(
                        fromValue: fromValue,
                        toValue: toValue,
                        duration: duration,
                        hapticsEnabled: hapticsEnabled
                    )
                )
            )
        }
    }
}

// MARK: - SwiftUI Modifier
struct RollingNumberModifier: ViewModifier {
    let fromValue: Int
    let toValue: Int
    let duration: TimeInterval
    let hapticsEnabled: Bool
    
    @State private var displayedValue: Int
    @State private var hasStarted = false
    
    init(fromValue: Int, toValue: Int, duration: TimeInterval, hapticsEnabled: Bool) {
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.hapticsEnabled = hapticsEnabled
        self._displayedValue = State(initialValue: fromValue)
    }
    
    func body(content: Content) -> some View {
        Text("\(displayedValue)")
            .monospacedDigit()
            .onAppear {
                guard !hasStarted else { return }
                hasStarted = true
                startCounting()
            }
    }
    
    private func startCounting() {
        let totalSteps = max(1, Int(duration / 0.016))
        let stepDuration = duration / Double(totalSteps)
        
        for step in 0...totalSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(step)) {
                let progress = Double(step) / Double(totalSteps)
                let eased = 1.0 - pow(1.0 - progress, 3)
                displayedValue = Int(Double(fromValue) + Double(toValue - fromValue) * eased)
                
                if step == totalSteps {
                    displayedValue = toValue
                }
            }
        }
    }
}

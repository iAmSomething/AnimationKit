import SwiftUI
import UIKit

/// Typewriter 애니메이션 프리셋
///
/// 텍스트가 한 글자씩 순서대로 나타나는 타이프라이터/타자기 효과입니다.
/// AI 챗봇 응답(ChatGPT UI), 게임 텍스트 대화창, 온보딩 스토리텔링에서 사용됩니다.
/// 각 글자가 일정 간격(characterDelay)으로 추가되며 커서 깜빡임 효과가 함께 적용됩니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ✅ (선택적) — 3글자마다 `selection` 햅틱 발생 (과부하 방지 스로틀링)
/// - **입력 매개변수**:
///   - `text` (String): 타이핑할 전체 텍스트
///   - `characterDelay` (TimeInterval, default: 0.05): 글자 간 간격 (초)
///   - `hapticsEnabled` (Bool, default: false): 햅틱 피드백 활성화 여부
/// - **관측 가능한 출력**:
///   - `revealedCharacterCount` (Int): 현재 표시된 글자 수
///
/// ## 사용 예시
/// ```swift
/// // SwiftUI
/// view.animationKitTypewriter(text: "안녕하세요!", hapticsEnabled: true)
///
/// // UIKit
/// view.animationKitTypewriter(text: "Hello World", hapticsEnabled: true)
/// ```
public struct TypewriterAnimation: SolarAnimatable {
    public let id: String = "typewriter"
    public let displayName: String = "타이프라이터 (글자별 등장)"
    public let description: String = "한 글자씩 순서대로 나타나는 타자기 효과. AI 챗봇 응답, 대화창에 적합."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(
        classType: .cpuBound,
        recommendedMaxInstances: 5
    )
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "text", type: "String", description: "타이핑할 전체 텍스트"),
        ParameterInfo(name: "characterDelay", type: "TimeInterval", defaultValue: "0.05", description: "글자 간 간격 (초)"),
        ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
    ])
    public let outputEffects: [ParameterInfo] = [
        ParameterInfo(name: "revealedCharacterCount", type: "Int", description: "현재 표시된 글자 수")
    ]
    public let iconName: String? = "character.cursor.ibeam"
    
    private let text: String
    private let characterDelay: TimeInterval
    private let hapticsEnabled: Bool
    
    public init(text: String, characterDelay: TimeInterval = 0.05, hapticsEnabled: Bool = false) {
        self.text = text
        self.characterDelay = characterDelay
        self.hapticsEnabled = hapticsEnabled
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation {
        .linear(duration: characterDelay)
    }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        let fullText = text
        let delay = characterDelay
        let haptic = hapticsEnabled
        
        return [.custom({ @MainActor layer, _ in
            guard let superview = layer.delegate as? UIView else { return }
            let targetLabel: UILabel? = superview as? UILabel ?? superview.subviews.compactMap { $0 as? UILabel }.first
            guard let label = targetLabel else { return }
            
            label.text = ""
            let characters = Array(fullText)
            
            final class Counter: @unchecked Sendable {
                var value: Int = 0
            }
            let counter = Counter()
            
            let timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { timer in
                guard counter.value < characters.count else {
                    timer.invalidate()
                    return
                }
                
                label.text = String(characters[0...counter.value])
                
                if haptic && counter.value % 3 == 0 {
                    HapticsGenerator.triggerSelection()
                }
                
                counter.value += 1
            }
            
            RunLoop.main.add(timer, forMode: .common)
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.modifier(
                    TypewriterModifier(
                        text: text,
                        characterDelay: characterDelay,
                        hapticsEnabled: hapticsEnabled
                    )
                )
            )
        }
    }
}

// MARK: - SwiftUI Modifier
struct TypewriterModifier: ViewModifier {
    let text: String
    let characterDelay: TimeInterval
    let hapticsEnabled: Bool
    
    @State private var displayedText: String = ""
    @State private var characterIndex: Int = 0
    @State private var timer: Timer?
    
    func body(content: Content) -> some View {
        Text(displayedText)
            .onAppear {
                startTyping()
            }
            .onDisappear {
                timer?.invalidate()
            }
    }
    
    private func startTyping() {
        let characters = Array(text)
        guard !characters.isEmpty else { return }
        
        displayedText = ""
        characterIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: characterDelay, repeats: true) { t in
            guard characterIndex < characters.count else {
                t.invalidate()
                return
            }
            
            displayedText = String(characters[0...characterIndex])
            characterIndex += 1
        }
        
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}

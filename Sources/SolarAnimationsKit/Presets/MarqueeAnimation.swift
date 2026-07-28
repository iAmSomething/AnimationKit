import SwiftUI
import UIKit

/// Marquee 애니메이션 프리셋
///
/// 텍스트가 뷰의 너비보다 길 경우, 가로로 무한 반복 스크롤되는 전광판 효과입니다.
///
/// ## Quick View
/// - **카테고리**: Advanced
/// - **햅틱 지원**: ❌
/// - **입력 매개변수**:
///   - `text` (String): 스크롤할 텍스트
///   - `font` (UIFont, default: .systemFont(ofSize: 16)): 텍스트 폰트
///   - `textColor` (UIColor, default: .label): 텍스트 색상
///   - `duration` (TimeInterval, default: 5.0): 한 사이클이 도는 데 걸리는 시간
/// - **관측 가능한 출력**: 없음
public struct MarqueeAnimation: SolarAnimatable {
    public let id: String = "marquee"
    public let displayName: String = "마키 (전광판 무한 스크롤)"
    public let description: String = "긴 텍스트를 한정된 영역에서 무한히 가로 스크롤하여 보여줍니다."
    public let category: String = "Advanced"
    public let performance: PerformanceProfile = PerformanceProfile(classType: .linearPerFrame, recommendedMaxInstances: 3)
    public let inputSchema = AnimationInputSchema([
        ParameterInfo(name: "text", type: "String", defaultValue: "", description: "스크롤할 텍스트"),
        ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "5.0", description: "한 사이클 시간")
    ])
    public let outputEffects: [ParameterInfo] = []
    public let iconName: String? = "text.and.command.macwindow"
    
    private let text: String
    private let font: UIFont
    private let textColor: UIColor
    private let duration: TimeInterval
    
    public init(text: String, font: UIFont = .systemFont(ofSize: 16), textColor: UIColor = .label, duration: TimeInterval = 5.0) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.duration = duration
    }
    
    public func makeSwiftUIAnimation() -> SwiftUI.Animation { .linear(duration: duration).repeatForever(autoreverses: false) }
    
    public func makeUIKitCommands() -> [AnimatableLayerCommand] {
        let t = text
        let f = font
        let tc = textColor
        let dur = duration
        
        return [.custom({ @MainActor layer, _ in
            let textLayer1 = CATextLayer()
            textLayer1.string = t
            textLayer1.font = f
            textLayer1.fontSize = f.pointSize
            textLayer1.foregroundColor = tc.cgColor
            textLayer1.contentsScale = UIScreen.main.scale
            textLayer1.alignmentMode = .left
            
            let nsText = t as NSString
            let size = nsText.size(withAttributes: [.font: f])
            let textWidth = size.width + 40 // Add padding
            let height = size.height
            
            textLayer1.frame = CGRect(x: 0, y: (layer.bounds.height - height)/2, width: textWidth, height: height)
            
            let textLayer2 = CATextLayer()
            textLayer2.string = t
            textLayer2.font = f
            textLayer2.fontSize = f.pointSize
            textLayer2.foregroundColor = tc.cgColor
            textLayer2.contentsScale = UIScreen.main.scale
            textLayer2.alignmentMode = .left
            textLayer2.frame = CGRect(x: textWidth, y: (layer.bounds.height - height)/2, width: textWidth, height: height)
            
            let scrollLayer = CALayer()
            scrollLayer.frame = CGRect(x: 0, y: 0, width: textWidth * 2, height: layer.bounds.height)
            scrollLayer.addSublayer(textLayer1)
            scrollLayer.addSublayer(textLayer2)
            
            layer.masksToBounds = true
            layer.addSublayer(scrollLayer)
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.fromValue = 0
            animation.toValue = -textWidth
            animation.duration = dur
            animation.repeatCount = .infinity
            animation.isRemovedOnCompletion = false
            
            scrollLayer.add(animation, forKey: "marqueeAnimation")
        })]
    }
    
    public func makeSwiftUIModifier() -> (AnyView) -> AnyView {
        return { view in
            AnyView(
                view.modifier(MarqueeModifier(text: text, duration: duration))
            )
        }
    }
}

struct MarqueeModifier: ViewModifier {
    let text: String
    let duration: TimeInterval
    
    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0

    nonisolated init(text: String, duration: TimeInterval) {
        self.text = text
        self.duration = duration
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            let w = textWidth > 0 ? textWidth + 40 : 1000
            HStack(spacing: 40) {
                Text(text).lineLimit(1).fixedSize()
                    .background(GeometryReader { textGeo in
                        Color.clear.onAppear {
                            textWidth = textGeo.size.width
                        }
                    })
                Text(text).lineLimit(1).fixedSize()
            }
            .offset(x: offset)
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    offset = -w
                }
            }
        }
        .clipped()
    }
}

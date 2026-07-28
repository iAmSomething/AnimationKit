import SwiftUI
import UIKit

public enum AnimationPreset: Sendable {
    case fade
    case slide(direction: SlideDirection, fromEdge: Edge)
    case slideOut(toEdge: Edge)
    case scaleUp
    case scaleDown
    case pop
    case shake
    case pulse
    case bounceIn
    case bounceOut
    case flip(axis: FlipAxis)
    case glow
    case spin(degrees: Double)
    case morph(initial: CGSize, final: CGSize)
    case emphasize
    case shimmer
    case confetti
    case rollingNumber(from: Int, to: Int)
    case ripple
    case tilt3d
    case typewriter(text: String)
    case gooey
    case custom(String)

    public var quickView: PresetMetadata {
        switch self {
        case .fade:
            return PresetMetadata(
                id: "fade", category: "Basic", title: "Fade",
                description: "뷰의 투명도를 0↔1로 변화. 모달, 오버레이에 적합.",
                inputs: [
                    ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "0.4"),
                    ParameterInfo(name: "delay", type: "TimeInterval", defaultValue: "0")
                ],
                outputs: [ParameterInfo(name: "alpha", type: "CGFloat", description: "최종 투명도")],
                performance: PerformanceProfile(classType: .gpuOptimized),
                iconName: "circle.fill"
            )
        case .slide(let direction, _):
            return PresetMetadata(
                id: "slide", category: "Transform", title: "Slide",
                description: "\(direction == .enter ? "가장자리에서 중앙으로" : "중앙에서 가장자리로") 이동.",
                inputs: [
                    ParameterInfo(name: "direction", type: "SlideDirection", defaultValue: "enter"),
                    ParameterInfo(name: "fromEdge", type: "Edge", defaultValue: "top"),
                    ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "0.4")
                ],
                outputs: [ParameterInfo(name: "frame.origin", type: "CGPoint", description: "최종 위치")],
                performance: PerformanceProfile(classType: .cpuBound),
                iconName: "arrow.down.right"
            )
        case .pop:
            return PresetMetadata(
                id: "pop", category: "Feedback", title: "Pop",
                description: "0 → 1.12배 → 1.0배로 바운스 확대. 버튼 탭 피드백에 최적.",
                inputs: [ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "0.3")],
                outputs: [
                    ParameterInfo(name: "transform.scale", type: "CGFloat", description: "최대 1.12 → 최종 1.0")
                ],
                performance: PerformanceProfile(classType: .gpuOptimized),
                iconName: "bolt.fill"
            )
        case .shake:
            return PresetMetadata(
                id: "shake", category: "Feedback", title: "Shake",
                description: "X축 방향으로 좌우 흔들림. 입력 오류 알림에 적합.",
                inputs: [
                    ParameterInfo(name: "intensity", type: "CGFloat", defaultValue: "8.0"),
                    ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "0.45")
                ],
                outputs: [ParameterInfo(name: "center.x", type: "CGFloat", description: "변동하는 X좌표")],
                performance: PerformanceProfile(classType: .linearPerFrame, recommendedMaxInstances: 20),
                iconName: "speaker.wave.2"
            )
        case .glow:
            return PresetMetadata(
                id: "glow", category: "Effect", title: "Glow",
                description: "그림자 글로우 생성 + 스케일 확대. 선택 상태 강조에 적합.",
                inputs: [
                    ParameterInfo(name: "color", type: "Color", defaultValue: "Theme.accentColor"),
                    ParameterInfo(name: "radius", type: "CGFloat", defaultValue: "8.0"),
                    ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "0.4")
                ],
                outputs: [
                    ParameterInfo(name: "shadowRadius", type: "CGFloat", description: "최종 그림자 반경")
                ],
                performance: PerformanceProfile(classType: .offscreenRisk, recommendedMaxInstances: 15),
                iconName: "sparkles"
            )
        case .spin:
            return PresetMetadata(
                id: "spin", category: "Transform", title: "Spin",
                description: "Z축 기준 회전. 로딩 스피너에 적합.",
                inputs: [
                    ParameterInfo(name: "degrees", type: "Double", defaultValue: "360"),
                    ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "1.0"),
                    ParameterInfo(name: "infinite", type: "Bool", defaultValue: "true")
                ],
                outputs: [ParameterInfo(name: "transform.rotation", type: "CGFloat", description: "최종 회전 각도")],
                performance: PerformanceProfile(classType: .gpuOptimized),
                iconName: "arrow.triangle.2.circlepath"
            )
        case .shimmer:
            return PresetMetadata(
                id: "shimmer", category: "Advanced", title: "시머 (빛 반사)",
                description: "스켈레톤 UI 로딩 화면의 빛 반사 효과. 콘텐츠 피드, 프로필 카드 플레이스홀더에 적합.",
                inputs: [
                    ParameterInfo(name: "isPlaying", type: "Bool", defaultValue: "true", description: "애니메이션 재생 여부")
                ],
                outputs: [],
                performance: PerformanceProfile(classType: .gpuOptimized, recommendedMaxInstances: 50),
                iconName: "sparkles.rectangle"
            )
        case .confetti:
            return PresetMetadata(
                id: "confetti", category: "Advanced", title: "컨페티 (축하 폭죽)",
                description: "CAEmitterLayer 기반 축하 파티클 효과. 결제 완료, 목표 달성 시 적합.",
                inputs: [
                    ParameterInfo(name: "isTriggered", type: "Bool", defaultValue: "false", description: "true로 변경 시 1회 폭죽 발사"),
                    ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
                ],
                outputs: [],
                performance: PerformanceProfile(classType: .linearPerFrame, recommendedMaxInstances: 1),
                iconName: "party.popper.fill"
            )
        case .rollingNumber(let from, let to):
            return PresetMetadata(
                id: "rollingNumber", category: "Advanced", title: "롤링 넘버 (숫자 티커)",
                description: "슬롯머신 스타일 숫자 스크롤 효과. 금융 앱 잔액, 점수판에 적합.",
                inputs: [
                    ParameterInfo(name: "fromValue", type: "Int", defaultValue: "\(from)", description: "시작 숫자"),
                    ParameterInfo(name: "toValue", type: "Int", defaultValue: "\(to)", description: "목표 숫자"),
                    ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
                ],
                outputs: [
                    ParameterInfo(name: "displayedValue", type: "Int", description: "현재 표시 중인 숫자 값")
                ],
                performance: PerformanceProfile(classType: .cpuBound, recommendedMaxInstances: 20),
                iconName: "number.circle.fill"
            )
        case .ripple:
            return PresetMetadata(
                id: "ripple", category: "Advanced", title: "리플 (물결 확산)",
                description: "터치 지점에서 퍼져나가는 잉크 드롭 효과. 버튼 탭 피드백에 적합.",
                inputs: [
                    ParameterInfo(name: "origin", type: "CGPoint", defaultValue: ".zero", description: "리플 시작 좌표"),
                    ParameterInfo(name: "color", type: "UIColor", defaultValue: ".systemBlue", description: "리플 색상"),
                    ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
                ],
                outputs: [
                    ParameterInfo(name: "rippleRadius", type: "CGFloat", description: "최종 리플 반경")
                ],
                performance: PerformanceProfile(classType: .linearPerFrame, recommendedMaxInstances: 10),
                iconName: "drop.circle.fill"
            )
        case .tilt3d:
            return PresetMetadata(
                id: "tilt3d", category: "Advanced", title: "3D 틸트 (패럴랙스)",
                description: "드래그 기반 3D 패럴랙스 카드 효과. 프리미엄 카드, 앨범 커버에 적합.",
                inputs: [
                    ParameterInfo(name: "maxAngle", type: "Double", defaultValue: "15.0", description: "최대 기울기 각도"),
                    ParameterInfo(name: "perspective", type: "CGFloat", defaultValue: "0.5", description: "원근감 강도"),
                    ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
                ],
                outputs: [
                    ParameterInfo(name: "rotationX", type: "Double", description: "현재 X축 회전 각도"),
                    ParameterInfo(name: "rotationY", type: "Double", description: "현재 Y축 회전 각도")
                ],
                performance: PerformanceProfile(classType: .gpuOptimized, recommendedMaxInstances: 10),
                iconName: "rotate.3d.fill"
            )
        case .typewriter(let text):
            return PresetMetadata(
                id: "typewriter", category: "Advanced", title: "타이프라이터 (글자별 등장)",
                description: "한 글자씩 순서대로 나타나는 타자기 효과. AI 챗봇 응답, 대화창에 적합.",
                inputs: [
                    ParameterInfo(name: "text", type: "String", defaultValue: text, description: "타이핑할 전체 텍스트"),
                    ParameterInfo(name: "characterDelay", type: "TimeInterval", defaultValue: "0.05", description: "글자 간 간격"),
                    ParameterInfo(name: "hapticsEnabled", type: "Bool", defaultValue: "false", description: "햅틱 피드백 활성화 여부")
                ],
                outputs: [
                    ParameterInfo(name: "revealedCharacterCount", type: "Int", description: "현재 표시된 글자 수")
                ],
                performance: PerformanceProfile(classType: .cpuBound, recommendedMaxInstances: 5),
                iconName: "character.cursor.ibeam"
            )
        case .gooey:
            return PresetMetadata(
                id: "gooey", category: "Advanced", title: "구이 (액체 모핑)",
                description: "블러+고대비 합성 기법의 액체 점성 효과. FAB 열기, 탭바 인디케이터에 적합.",
                inputs: [
                    ParameterInfo(name: "blurRadius", type: "CGFloat", defaultValue: "20", description: "블러 반경"),
                    ParameterInfo(name: "isActive", type: "Bool", defaultValue: "true", description: "효과 활성화 여부")
                ],
                outputs: [],
                performance: PerformanceProfile(classType: .offscreenRisk, estimatedMemoryFootprint: "Medium (~10KB)", recommendedMaxInstances: 3),
                iconName: "drop.fill"
            )
        default:
            return PresetMetadata(
                id: "default", category: "Other", title: "Animation",
                description: "기본 애니메이션.",
                inputs: [ParameterInfo(name: "duration", type: "TimeInterval", defaultValue: "0.4")],
                outputs: [],
                performance: PerformanceProfile(classType: .gpuOptimized),
                iconName: "sparkles"
            )
        }
    }
}

public enum SlideDirection: Sendable { case enter, exit }
public enum Edge: Sendable { case top, bottom, leading, trailing }
public enum FlipAxis: Sendable { case x, y, z }

public protocol AnimationPresetProtocol: Sendable {
    var theme: AnimationTheme { get }
    var duration: TimeInterval { get set }
    var delay: TimeInterval { get set }
    func makeSwiftUIAnimation() -> SwiftUI.Animation
    func makeUIKitAnimations() -> [AnimatableLayerCommand]
}

# 🌞 SolarAnimationKit

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/packages)

> **A protocol-oriented, performance-aware iOS animation framework for SwiftUI & UIKit.**  
> **SwiftUI와 UIKit을 위한 프로토콜 지향, 성능 최적화 iOS 애니메이션 프레임워크입니다.**

SolarAnimationKit provides **40+ built-in animations** including **advanced UI effects (Gooey, 3D Tilt, Confetti)** with **performance metadata**, **memory leak protection**, and a **protocol-based architecture** that lets you add custom animations in under 10 lines of code.

SolarAnimationKit은 **40개 이상의 기본 애니메이션**과 **고급 UI 효과(Gooey, 3D Tilt, Confetti 등)**를 제공합니다. **성능 메타데이터**, **메모리 누수 방지** 및 10줄 이하의 코드로 커스텀 애니메이션을 추가할 수 있는 **프로토콜 기반 아키텍처**를 특징으로 합니다.

---

## ✨ Features / 주요 기능

- 🎨 **40+ Built-in Animations**: Fade, Pop, Shake, Glow, Spin, Flip, Morph, and more.  
  (40개 이상의 내장 애니메이션 제공)
- 🚀 **Advanced Effects**: Ripple, 3D Tilt, Gooey, Rolling Number, Typewriter, Shimmer, Confetti.  
  (고급 UI 이펙트 지원)
- 📳 **Haptic Feedback Integration**: Built-in, zero-configuration haptics for premium feel (`hapticsEnabled` flag).  
  (별도 설정 없는 내장 햅틱 피드백 연동)
- 📊 **Performance-Aware**: Each animation includes `PerformanceProfile` (GPU/CPU/Offscreen risk).  
  (모든 애니메이션에 대한 GPU/CPU 성능 프로필 제공)
- 🛡️ **Leak-Protected**: Architecture designed to prevent retain cycles and memory leaks.  
  (순환 참조 및 메모리 누수 방지 설계)
- 🔌 **Protocol-Oriented**: Add custom animations easily by conforming to `SolarAnimatable`.  
  (프로토콜 기반의 손쉬운 커스텀 애니메이션 확장)
- 📱 **Dual Platform**: Unified API for both SwiftUI and UIKit (`.animationKit`).  
  (SwiftUI와 UIKit을 위한 통합 API)
- 🎛️ **Theme System**: Global styling with `AnimationKit.theme`.  
  (글로벌 테마 시스템 제공)
- ✅ **Swift 6 Ready**: Completely compliant with Swift 6 strict concurrency (`@MainActor`, `@Sendable`).  
  (Swift 6 Strict Concurrency 완벽 대응)
- 🧪 **Fully Tested**: Covered by Unit Tests and `swift-snapshot-testing` for visual regression.  
  (단위 테스트 및 스냅샷 테스트를 통한 시각적 회귀 방지)

---

## 📦 Installation / 설치 방법

### Swift Package Manager

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/yourname/SolarAnimationKit.git", from: "1.0.0")
]
```

Or via **Xcode → File → Add Packages...** and enter the URL.  
(또는 Xcode의 Add Packages 메뉴를 통해 URL을 입력하여 설치할 수 있습니다.)

---

## 🚀 Quick Start / 빠른 시작

```swift
import SolarAnimationKit

// 1. Configure theme (optional, app startup) / 테마 설정 (선택사항)
AnimationKit.theme = .darkAccent

// 2. Register custom animations (optional) / 커스텀 애니메이션 등록 (선택사항)
AnimationKit.register(WiggleAnimation())
```

### 📱 SwiftUI Usage / SwiftUI 사용법

SolarAnimationKit provides easy-to-use ViewModifiers for SwiftUI.  
(SwiftUI를 위한 직관적인 ViewModifier를 제공합니다.)

```swift
// Basic Animations / 기본 애니메이션
Text("Hello")
    .animationKit(.pop, trigger: isPressed)
    .animationKitShake(visible: hasError)

// Advanced Animations with Haptics / 햅틱이 적용된 고급 애니메이션
Circle()
    .animationKitRipple(origin: touchPoint, color: .blue, hapticsEnabled: true)

Text(priceString)
    .animationKitRollingNumber(fromValue: 0, toValue: 1500, hapticsEnabled: true)
```

### 🖥️ UIKit Usage / UIKit 사용법

You can use the exact same animations on any `UIView` or `CALayer`.  
(어떤 UIView나 CALayer에서도 동일한 애니메이션 API를 사용할 수 있습니다.)

```swift
// Basic Animations / 기본 애니메이션
view.animationKit(.fade, duration: 0.3)
button.animationKitPop()

// Advanced Animations / 고급 애니메이션
view.animationKitConfetti(isTriggered: true, hapticsEnabled: true)
label.animationKitTypewriter(text: "Hello World", characterDelay: 0.05, hapticsEnabled: true)
```

---

## 🌟 Advanced Presets / 고급 프리셋

We provide complex, production-ready presets out of the box. Click on each animation to see detailed documentation and demo GIFs:  
(실무에 바로 적용 가능한 복잡한 애니메이션 프리셋을 기본 제공합니다. 각 애니메이션을 클릭하여 상세 문서와 시연 GIF를 확인하세요:)

- [**Confetti**](docs/Animations/Confetti.md): High-performance particle system using `CAEmitterLayer`. Perfect for celebrations and goal completions.  
  (CAEmitterLayer 기반 고성능 파티클 시스템. 결제 완료나 목표 달성에 적합합니다.)
- [**Shimmer**](docs/Animations/Shimmer.md): Light reflection effect commonly used in skeleton UI loading screens.  
  (스켈레톤 UI 로딩 화면에서 자주 사용되는 빛 반사 효과입니다.)
- [**Rolling Number**](docs/Animations/RollingNumber.md): Slot-machine style number scrolling effect for balances or scores.  
  (금융 앱 잔액 표시 등에 적합한 슬롯머신 스타일의 숫자 스크롤 효과입니다.)
- [**Ripple**](docs/Animations/Ripple.md): Material Design style ink drop effect spreading from a touch point.  
  (터치 지점에서 퍼져나가는 Material Design 스타일의 잉크 드롭 효과입니다.)
- [**3D Tilt**](docs/Animations/Tilt3D.md): Drag-based 3D parallax card effect. Great for premium card UIs.  
  (드래그 기반 3D 패럴랙스 카드 효과. 프리미엄 카드 UI에 적합합니다.)
- [**Typewriter**](docs/Animations/Typewriter.md): Character-by-character text reveal effect. Ideal for chatbot responses.  
  (한 글자씩 순서대로 나타나는 효과. 챗봇 응답 텍스트 표시에 적합합니다.)
- [**Gooey**](docs/Animations/Gooey.md): Liquid/gooey morphing effect using blur + contrast threshold technique. Ideal for FAB menus or tab bar indicators.  
  (블러와 고대비 합성 기법을 활용한 액체 점성 모핑 효과. FAB 메뉴 열기나 탭바 인디케이터에 적합합니다.)
- [**Sparkle**](docs/Animations/Sparkle.md): Twitter-like like button particle explosion effect.  
  (트위터 좋아요 버튼 스타일의 흩뿌려지는 원형 파티클 폭발 효과입니다.)
- [**Marquee**](docs/Animations/Marquee.md): Infinite horizontal scrolling for long text within a constrained area.  
  (한정된 영역에서 넘치는 텍스트를 무한히 가로 스크롤하여 보여주는 전광판 효과입니다.)
- [**Progressive Blur**](docs/Animations/ProgressiveBlur.md): A smooth gradient-masked blur effect for premium glassmorphism UIs.  
  (그라데이션 마스크를 통해 서서히 흐려지는 고급스러운 Glassmorphism 블러 효과를 제공합니다.)
- [**Pulse**](docs/Animations/Pulse.md): Infinite radiating wave effect. Perfect for live indicators or recording buttons.  
  (중심에서 밖으로 퍼져나가는 무한 파장 효과. 라이브 인디케이터나 녹음 버튼 등에 사용됩니다.)
- [**Rubberband**](docs/Animations/Rubberband.md): Spring tension drag effect providing physical resistance feedback.  
  (드래그 시 물리적인 텐션 저항을 느끼게 하고 놓으면 원래 자리로 탄력 있게 돌아가는 고무줄 효과입니다.)

---


## 📳 Haptics Architecture / 햅틱 아키텍처

All advanced presets support the `hapticsEnabled` parameter. Whether using SwiftUI or UIKit, the `HapticsGenerator` automatically triggers the most appropriate feedback (`.success`, `.selection`, `.impact`) at the exact moment the animation command executes.

모든 고급 프리셋은 `hapticsEnabled` 파라미터를 제공합니다. SwiftUI와 UIKit 구분 없이, 애니메이션 커맨드가 실행되는 정확한 타이밍에 `HapticsGenerator`를 통해 가장 적절한 피드백이 트리거되어 시각 효과와 완벽하게 동기화됩니다.

```swift
view.animationKitConfetti(isTriggered: true, hapticsEnabled: true)
```

---

## 🧪 Testing / 테스트

SolarAnimationsKit is rigorously tested to ensure performance and visual consistency:  
(본 프레임워크는 성능과 시각적 일관성을 보장하기 위해 철저하게 테스트되었습니다.)

1. **Metadata Tests**: Verifies catalog integrity, localization, and parameter schemas. (메타데이터 및 카탈로그 무결성 검증)
2. **UIKit Commands Tests**: Validates `AnimatableLayerCommand` arrays generation. (렌더링 없는 커맨드 로직 검증)
3. **Snapshot Tests**: Uses [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) for pixel-perfect visual regression testing. (UI 스냅샷을 통한 시각적 회귀 테스트)

```bash
xcodebuild test -scheme SolarAnimationsKit -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.2'
```

---

## 📜 License / 라이선스

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.  
(이 프로젝트는 MIT 라이선스로 배포됩니다. 자세한 내용은 LICENSE 파일을 참고하세요.)

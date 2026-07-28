# Typewriter Animation (Advanced)

> 텍스트가 한 글자씩 순서대로 타이핑되듯 나타나는 효과입니다.

## 🎞️ Demo / 데모

![Typewriter Demo GIF Placeholder](../../Assets/typewriter.gif)

*(이곳에 Typewriter 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: 지정한 타이머 딜레이(`characterDelay`)에 맞춰 텍스트를 프로그레시브하게 노출합니다.
- **용도**: AI 챗봇 응답, 게임 스토리 텍스트, 사용자 시선을 집중시켜야 하는 온보딩 메시지.
- **햅틱 연동**: 글자가 찍힐 때마다 미세한 햅틱 피드백을 제공하여 타건감을 에뮬레이트합니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
// SwiftUI 사용 예시
Text(animatedText)
    .animationKitTypewriter(text: "안녕하세요, SolarAnimationKit 입니다.", characterDelay: 0.05, hapticsEnabled: true)
```

### UIKit

```swift
// UIKit 사용 예시
messageLabel.animationKitTypewriter(text: "환영합니다!", characterDelay: 0.05, hapticsEnabled: true)
```

---
[🔙 Back to Home](../../README.md)

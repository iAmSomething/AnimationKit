# Confetti Animation (Advanced)

> CAEmitterLayer를 기반으로 한 고성능 파티클 폭죽 애니메이션입니다. 결제 완료나 레벨업 등 성공적인 사용자 액션을 축하할 때 완벽합니다.

## 🎞️ Demo / 데모

![Confetti Demo GIF Placeholder](../../Assets/confetti.gif)

*(이곳에 Confetti 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: 중력, 바람, 회전 등 물리 기반 파티클 시스템을 구현하여 매우 자연스럽습니다.
- **디자인 철학**: 사용자에게 즉각적이고 강렬한 성취감을 부여합니다.
- **햅틱 연동**: `UINotificationFeedbackGenerator(style: .success)`와 결합하여 폭죽이 터질 때 촉각적 쾌감을 줍니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
// SwiftUI 사용 예시
Button("결제 완료") {
    isTriggered = true
}
.animationKitConfetti(isTriggered: isTriggered, hapticsEnabled: true)
```

### UIKit

```swift
// UIKit 사용 예시
button.addAction(UIAction { _ in
    view.animationKitConfetti(isTriggered: true, hapticsEnabled: true)
}, for: .touchUpInside)
```

---
[🔙 Back to Home](../../README.md)

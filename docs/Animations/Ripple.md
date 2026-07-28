# Ripple Animation (Advanced)

> 사용자가 탭한 위치에서 물결이 퍼져나가는 잉크 드롭(Ink-drop) 효과입니다.

## 🎞️ Demo / 데모

![Ripple Demo GIF Placeholder](../../Assets/ripple.gif)

*(이곳에 Ripple 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: 머티리얼 디자인(Material Design) 스타일의 반응형 탭 효과입니다.
- **디자인 철학**: 사용자의 터치 위치에 직접적인 피드백을 주어 시스템이 반응하고 있음을 확신하게 합니다.
- **햅틱 연동**: `triggerImpact(style: .medium)`과 결합되어 화면을 누를 때 물리적인 반응을 체감하게 합니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
// SwiftUI 사용 예시
Color.clear
    .contentShape(Rectangle())
    .onTapGesture(coordinateSpace: .local) { location in
        touchLocation = location
    }
    .animationKitRipple(origin: touchLocation, color: .blue.opacity(0.3), hapticsEnabled: true)
```

### UIKit

```swift
// UIKit 사용 예시
// 터치 이벤트를 받아 좌표를 넘겨줍니다.
view.animationKitRipple(origin: touchPoint, color: UIColor.systemBlue.withAlphaComponent(0.3), hapticsEnabled: true)
```

---
[🔙 Back to Home](../../README.md)

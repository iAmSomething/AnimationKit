# Rolling Number Animation (Advanced)

> 슬롯머신처럼 숫자가 아래에서 위로 회전하며 변경되는 카운터 효과입니다.

## 🎞️ Demo / 데모

![RollingNumber Demo GIF Placeholder](../../Assets/rollingnumber.gif)

*(이곳에 RollingNumber 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: 각 자릿수별로 독립적인 스프링 애니메이션이 적용됩니다.
- **용도**: 포인트 적립, 잔고 변동, 스코어 증가 등 수치의 변화를 역동적으로 보여줄 때 사용합니다.
- **햅틱 연동**: 숫자가 변경되며 멈출 때마다 `triggerSelection()` 미세 진동을 발생시킵니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
// SwiftUI 사용 예시
Text("\(points)")
    .animationKitRollingNumber(fromValue: 0, toValue: points, hapticsEnabled: true)
```

### UIKit

```swift
// UIKit 사용 예시
scoreLabel.animationKitRollingNumber(fromValue: oldScore, toValue: newScore, hapticsEnabled: true)
```

---
[🔙 Back to Home](../../README.md)

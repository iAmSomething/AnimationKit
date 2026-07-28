# Pulse Animation (Advanced)

> 뷰 주위로 은은한 원형 파장이 부드럽게 퍼져나가며 사라지는 숨쉬기 효과입니다.

## 🎞️ Demo / 데모

![Pulse Demo GIF Placeholder](../../Assets/pulse.gif)

*(이곳에 Pulse 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: 무한 루프와 타이밍 커브, 투명도 변화를 자연스럽게 맞추어 부드러운 숨쉬기 효과를 연출합니다.
- **실용성**: "현재 라이브 방송 중", "GPS 내 위치 탐색 중", "마이크 녹음 중"처럼 사용자의 주의를 지속적으로 끌어야 하는 상태 표시(Indicator)에 주로 쓰입니다.
- **조작**: 파장의 크기(Scale)와 주기(Duration), 색상 등을 자유롭게 커스텀할 수 있습니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
import SwiftUI
import SolarAnimationsKit

struct LiveIndicatorView: View {
    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 20, height: 20)
            .animationKitPulse(isActive: true, color: .red, duration: 2.0, scale: 2.5)
    }
}
```

### UIKit

```swift
import UIKit
import SolarAnimationsKit

let recordingDot = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
recordingDot.backgroundColor = .systemRed
recordingDot.layer.cornerRadius = 10

recordingDot.animationKitPulse(isActive: true, color: .systemRed, duration: 2.0, scale: 2.5)
```

---
[🔙 Back to Home](../../README.md)

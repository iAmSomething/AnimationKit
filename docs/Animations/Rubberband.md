# Rubberband Animation (Advanced)

> 뷰를 스크롤이나 드래그로 한계치까지 당겼을 때, 스프링처럼 쫀득하게 저항하다가 놓으면 튕겨져 돌아가는 텐션 효과입니다.

## 🎞️ Demo / 데모

![Rubberband Demo GIF Placeholder](../../Assets/rubberband.gif)

*(이곳에 Rubberband 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: 물리 엔진의 탄성 수식을 적용해 실제 스프링이나 고무줄처럼 쫀득하고 생동감 있는 저항을 구현합니다.
- **실용성**: 커스텀 바텀 시트(Bottom Sheet), 스와이프 가능한 카드뷰 등 터치 인터페이스에서 손맛과 피드백을 살려줄 때 매우 유용합니다.
- **햅틱 연동**: 한계치에서 튕길 때 햅틱 피드백을 제공하여 더욱 물리적인 느낌을 줄 수 있습니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
import SwiftUI
import SolarAnimationsKit

struct SwipeCardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.blue)
            .frame(width: 300, height: 200)
            .overlay(
                Text("당겨보세요!")
                    .foregroundColor(.white)
                    .font(.title)
            )
            .animationKitRubberband(tension: 0.8, hapticsEnabled: true)
    }
}
```

### UIKit

```swift
import UIKit
import SolarAnimationsKit

let cardView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
cardView.backgroundColor = .systemBlue
cardView.layer.cornerRadius = 20

// 드래그 제스처 및 애니메이션이 자동으로 추가됩니다.
cardView.animationKitRubberband(tension: 0.8, hapticsEnabled: true)
```

---
[🔙 Back to Home](../../README.md)

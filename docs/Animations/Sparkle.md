# Sparkle Animation (Advanced)

> 트위터(X)의 하트 버튼이나 인스타그램 좋아요처럼, 탭하면 주변으로 작은 별이나 파티클이 톡톡 터지는 효과입니다.

## 🎞️ Demo / 데모

![Sparkle Demo GIF Placeholder](../../Assets/sparkle.gif)

*(이곳에 Sparkle 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: 단순히 크기만 커지는 `Pop`과 달리, 여러 개의 작은 파티클(도형)이 사방으로 퍼졌다가 사라지는 정교한 파티클 애니메이션입니다.
- **실용성**: 커머스의 찜하기, SNS 좋아요, 관심 설정 등 긍정적 피드백이 필요한 모든 곳에 쓰입니다.
- **햅틱 연동**: 터치 시 가벼운 햅틱 피드백을 발생시켜 촉각적 만족감을 더합니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
import SwiftUI
import SolarAnimationsKit

struct LikeButtonView: View {
    @State private var isLiked = false
    
    var body: some View {
        Button(action: {
            isLiked.toggle()
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .gray)
                .font(.system(size: 40))
        }
        .animationKitSparkle(isTriggered: isLiked, color: .red, hapticsEnabled: true)
    }
}
```

### UIKit

```swift
import UIKit
import SolarAnimationsKit

let likeButton = UIButton(type: .system)
likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
likeButton.tintColor = .systemRed

likeButton.addAction(UIAction { [weak likeButton] _ in
    likeButton?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    likeButton?.animationKitSparkle(isTriggered: true, color: .systemRed, hapticsEnabled: true)
}, for: .touchUpInside)
```

---
[🔙 Back to Home](../../README.md)

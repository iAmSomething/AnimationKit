# 3D Tilt Animation (Advanced)

> 드래그 제스처에 따라 카드가 3D 입체로 기울어지는 패럴랙스 효과입니다.

## 🎞️ Demo / 데모

![Tilt3D Demo GIF Placeholder](../../Assets/tilt3d.gif)

*(이곳에 Tilt3D 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: `CATransform3D`의 m34 원근(Perspective)을 적용하여 깊이감을 생성합니다.
- **용도**: 앨범 아트워크, 프리미엄 멤버십 카드, 애플 TV 스타일의 하이라이트 UI.
- **햅틱 연동**: 최대 기울기 임계치에 도달할 때 미세한 경계 진동(`.selection`)을 제공합니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
// SwiftUI 사용 예시
Image("premiumCard")
    .resizable()
    .animationKitTilt3D(maxAngle: 15.0, perspective: 0.5, hapticsEnabled: true)
```

### UIKit

```swift
// UIKit 사용 예시
cardView.animationKitTilt3D(maxAngle: 15.0, perspective: 0.5, hapticsEnabled: true)
```

---
[🔙 Back to Home](../../README.md)

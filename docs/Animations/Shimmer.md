# Shimmer Animation (Advanced)

> 화면 요소가 로딩 중일 때 시각적인 지루함을 덜어주는 반사광 효과입니다.

## 🎞️ Demo / 데모

![Shimmer Demo GIF Placeholder](../../Assets/shimmer.gif)

*(이곳에 Shimmer 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: `CAGradientLayer`를 활용하여 빛이 지나가는 듯한 부드러운 전환을 생성합니다.
- **디자인 철학**: 데이터를 기다리는 시간을 시각적으로 채워주어 체감 대기 시간을 줄입니다.
- **용도**: 프로필 이미지 공간, 텍스트 플레이스홀더, 리스트 스켈레톤 뷰.

## 💻 Usage / 사용법

### SwiftUI

```swift
// SwiftUI 사용 예시
RoundedRectangle(cornerRadius: 12)
    .fill(Color.gray.opacity(0.3))
    .frame(height: 100)
    .animationKitShimmer(isPlaying: isLoading)
```

### UIKit

```swift
// UIKit 사용 예시
let placeholderView = UIView()
placeholderView.backgroundColor = .systemGray5
placeholderView.layer.cornerRadius = 12
placeholderView.animationKitShimmer(isPlaying: true)
```

---
[🔙 Back to Home](../../README.md)

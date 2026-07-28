# Gooey Animation (Advanced)

> 블러 필터와 고대비(Contrast) 효과를 이용해 원형 객체들이 액체처럼 끈적하게 달라붙는 메타볼(Metaball) 효과입니다.

## 🎞️ Demo / 데모

![Gooey Demo GIF Placeholder](../../Assets/gooey.gif)

*(이곳에 Gooey 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: 렌더링 계층에서 블러된 픽셀들의 알파 값을 조정하여 병합 효과를 냅니다.
- **용도**: 팹(FAB) 버튼 확장 메뉴, 액체형 로딩 스피너, 트렌디한 마이크로 인터랙션.

## 💻 Usage / 사용법

### SwiftUI

```swift
// SwiftUI 사용 예시
ZStack {
    Circle().frame(width: 50).offset(x: isExpanded ? -50 : 0)
    Circle().frame(width: 50).offset(x: isExpanded ? 50 : 0)
}
.animationKitGooey(blurRadius: 20, isActive: true)
```

### UIKit

```swift
// UIKit 사용 예시
// 부모 컨테이너 레이어에 적용
containerView.animationKitGooey(blurRadius: 20, isActive: true)
```

---
[🔙 Back to Home](../../README.md)

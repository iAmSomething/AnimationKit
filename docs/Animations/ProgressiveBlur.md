# Progressive Blur Animation (Advanced)

> Apple Music의 가사창 뒷배경이나 지도 앱의 네비게이션 바처럼, 한쪽 방향으로 갈수록 서서히 블러(흐림)가 강해지는 고급 효과입니다.

## 🎞️ Demo / 데모

![Progressive Blur Demo GIF Placeholder](../../Assets/progressive_blur.gif)

*(이곳에 Progressive Blur 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: `UIVisualEffectView`와 마스크를 활용해 점진적으로 흐려지는 효과를 구현합니다.
- **디자인 트렌드**: 최근 iOS 디자인 트렌드인 Glassmorphism에서 텍스트 가독성을 높이면서도 프리미엄한 느낌을 줄 때 주로 사용됩니다.
- **성능**: 렌더링 최적화를 거쳐 GPU 친화적으로 동작합니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
import SwiftUI
import SolarAnimationsKit

struct NavBarView: View {
    var body: some View {
        VStack {
            Text("네비게이션 타이틀")
                .font(.headline)
                .padding()
            Spacer()
        }
        .background(
            Color.clear
                .animationKitProgressiveBlur(blurStyle: .regular, direction: .topToBottom)
        )
    }
}
```

### UIKit

```swift
import UIKit
import SolarAnimationsKit

let blurContainer = UIView()
blurContainer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)

blurContainer.animationKitProgressiveBlur(blurStyle: .systemMaterial, direction: .topToBottom)
view.addSubview(blurContainer)
```

---
[🔙 Back to Home](../../README.md)

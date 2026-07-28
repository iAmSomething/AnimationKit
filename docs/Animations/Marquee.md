# Marquee Animation (Advanced)

> 텍스트가 뷰의 너비보다 길 경우, 음악 앱의 곡 제목처럼 왼쪽으로 스르륵 밀려나며 무한 반복되는 전광판 텍스트 효과입니다.

## 🎞️ Demo / 데모

![Marquee Demo GIF Placeholder](../../Assets/marquee.gif)

*(이곳에 Marquee 애니메이션을 시연하는 GIF 이미지를 추가하세요)*

## 📝 Description / 상세 설명

- **특징**: 텍스트 너비 계산, 끊김 없는 애니메이션 루프, 화면을 벗어났을 때의 처리 등을 완벽하게 처리한 무한 스크롤 컴포넌트입니다.
- **실용성**: 음악 플레이어 곡명 표시, 좁은 UI 내의 공지사항 띠 배너, 금융 앱의 뉴스 티커 등에 필수적입니다.
- **최적화**: CoreAnimation을 활용하여 60fps로 매끄럽게 동작합니다.

## 💻 Usage / 사용법

### SwiftUI

```swift
import SwiftUI
import SolarAnimationsKit

struct NoticeBannerView: View {
    var body: some View {
        Text("오늘의 특가 상품이 도착했습니다! 지금 바로 확인해보세요. 한정 수량 제공됩니다.")
            .font(.headline)
            .animationKitMarquee(text: "오늘의 특가 상품이 도착했습니다! 지금 바로 확인해보세요. 한정 수량 제공됩니다.", duration: 8.0)
            .frame(height: 50)
            .padding()
            .background(Color.yellow.opacity(0.3))
            .cornerRadius(12)
    }
}
```

### UIKit

```swift
import UIKit
import SolarAnimationsKit

let noticeLabel = UILabel()
noticeLabel.text = "긴 공지사항 텍스트가 계속해서 흘러갑니다..."
noticeLabel.font = .systemFont(ofSize: 16, weight: .bold)

// UIKit의 extension 활용
noticeLabel.animationKitMarquee(text: noticeLabel.text ?? "", duration: 8.0)
```

---
[🔙 Back to Home](../../README.md)

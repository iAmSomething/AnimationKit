import SwiftUI

struct AnimationKitModifier: ViewModifier {
    let preset: AnimationPreset
    let trigger: Bool
    let duration: TimeInterval?
    let delay: TimeInterval

    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .onChange(of: trigger, perform: { newValue in
                withAnimation(
                    AnimationKit.theme.timingCurve.swiftUIAnimation(duration: duration ?? AnimationKit.theme.defaultDuration)
                ) {
                    isVisible = newValue
                }
            })
            .opacity(isVisible ? 1 : 0)
    }
}

struct EmphasizeModifier: ViewModifier {
    let tapped: Bool
    @State private var scale: CGFloat = 1

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .shadow(color: Color(uiColor: AnimationKit.theme.shadowColor?.uiColor ?? .black).opacity(0.3),
                    radius: tapped ? AnimationKit.theme.glowRadius : 0,
                    y: tapped ? 3 : 0)
            .onChange(of: tapped, perform: { newValue in
                withAnimation(.easeOut(duration: 0.15)) {
                    scale = newValue ? AnimationKit.theme.emphasizeScale : 1
                }
            })
    }
}

extension AnimationTimingCurve {
    func swiftUIAnimation(duration: TimeInterval) -> SwiftUI.Animation {
        switch self {
        case .easeIn: .easeIn(duration: duration)
        case .easeOut: .easeOut(duration: duration)
        case .easeInOut: .easeInOut(duration: duration)
        case .linear: .linear(duration: duration)
        case .spring: .interpolatingSpring(mass: 1, stiffness: 120, damping: 0.7, initialVelocity: 0)
        }
    }
}

import SwiftUI

public struct AnimationCatalogView: View {
    @State private var selectedPreset: AnimationPreset?
    @State private var previewTrigger = false

    public init() {}

    public var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(presets.filter { $0.quickView.category == category }, id: \.quickView.id) { preset in
                            NavigationLink(destination: PresetDetailView(preset: preset)) {
                                PresetRowView(preset: preset)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Animation Kit Catalog")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var categories: [String] {
        Set(presets.map { $0.quickView.category }).sorted()
    }

    private var presets: [AnimationPreset] {
        [.fade, .slide(direction: .enter, fromEdge: .top), .pop, .shake, .glow, .spin(degrees: 360)]
    }
}

struct PresetRowView: View {
    let preset: AnimationPreset
    let metadata: PresetMetadata

    init(preset: AnimationPreset) {
        self.preset = preset
        self.metadata = preset.quickView
    }

    var body: some View {
        HStack {
            if let icon = metadata.iconName {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 30)
            } else {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .frame(width: 30)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(metadata.title)
                    .font(.headline)
                Text(metadata.description)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(metadata.performance.performanceLabel)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(metadata.performance.classType == .gpuOptimized ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                .cornerRadius(4)

            if metadata.performance.safetyWarning != nil {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.caption2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PresetDetailView: View {
    let preset: AnimationPreset
    let metadata: PresetMetadata
    @State private var trigger = false

    init(preset: AnimationPreset) {
        self.preset = preset
        self.metadata = preset.quickView
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                previewSection
                descriptionSection
                parametersSection
                outputsSection
                performanceSection
                codeExampleSection
            }
            .padding()
        }
        .navigationTitle(metadata.title)
        .onAppear { trigger = true }
    }

    private var previewSection: some View {
        VStack {
            Text("미리보기 (탭하여 재실행)")
                .font(.caption)
                .foregroundColor(.secondary)
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 150)
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.3))
                    .frame(height: 150)
                    .animationKit(preset, trigger: trigger)
                    .id(trigger)
            }
            .frame(height: 160)
            .onTapGesture { trigger.toggle() }
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("동작 설명")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(metadata.description)
                .font(.body)
                .lineSpacing(4)
        }
    }

    private var parametersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("입력 매개변수")
                .font(.caption)
                .foregroundColor(.secondary)
            ForEach(metadata.inputs, id: \.name) { param in
                HStack {
                    Text(param.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(param.type)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 4)
                Text(param.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }

    private var outputsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("관측 가능한 효과")
                .font(.caption)
                .foregroundColor(.secondary)
            ForEach(metadata.outputs, id: \.name) { output in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text("\(output.name) (\(output.type))")
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.vertical, 2)
                Text(output.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }

    private var performanceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("성능 프로파일")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                Text(metadata.performance.performanceLabel)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(metadata.performance.estimatedMemoryFootprint)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            if let warning = metadata.performance.safetyWarning {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    Text(warning)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.red.opacity(0.05))
                .cornerRadius(8)
            }
            Text("권장 최대 동시 인스턴스: \(metadata.performance.recommendedMaxInstances)개")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }

    private var codeExampleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("사용 예시")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("SwiftUI")
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("```swift")
                .font(.system(.caption, design: .monospaced))
            Text("// \(metadata.title) 적용")
                .font(.system(.caption, design: .monospaced))
            Text("view.animationKit(")
                .font(.system(.caption, design: .monospaced))
            + Text(presetDescription())
                .font(.system(.caption, design: .monospaced))
            + Text(")\n```")
                .font(.system(.caption, design: .monospaced))
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }

    private func presetDescription() -> String {
        switch preset {
        case .fade: return ".fade"
        case .slide(let dir, let edge): return ".slide(direction: .\(dir), fromEdge: .\(edge))"
        case .slideOut(let edge): return ".slideOut(toEdge: .\(edge))"
        case .scaleUp: return ".scaleUp"
        case .scaleDown: return ".scaleDown"
        case .pop: return ".pop"
        case .shake: return ".shake"
        case .pulse: return ".pulse"
        case .bounceIn: return ".bounceIn"
        case .bounceOut: return ".bounceOut"
        case .flip(let axis): return ".flip(axis: .\(axis))"
        case .glow: return ".glow"
        case .spin(let deg): return ".spin(degrees: \(deg))"
        case .morph: return ".morph(initial: ..., final: ...)"
        case .emphasize: return ".emphasize"
        case .shimmer: return ".shimmer"
        case .confetti: return ".confetti"
        case .rollingNumber(let from, let to): return ".rollingNumber(from: \(from), to: \(to))"
        case .ripple: return ".ripple"
        case .tilt3d: return ".tilt3d"
        case .typewriter(let text): return ".typewriter(text: \"\(text)\")"
        case .gooey: return ".gooey"
        case .custom: return ".custom(name: \"...\")"
        }
    }
}

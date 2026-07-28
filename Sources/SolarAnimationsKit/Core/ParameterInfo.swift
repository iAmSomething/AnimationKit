import Foundation

public struct ParameterInfo: Sendable, Identifiable {
    public let id: String
    public let name: String
    public let type: String
    public let defaultValue: String?
    public let description: String
    public let isOptional: Bool

    public init(
        name: String,
        type: String,
        defaultValue: String? = nil,
        description: String = "",
        isOptional: Bool = true
    ) {
        self.id = name
        self.name = name
        self.type = type
        self.defaultValue = defaultValue
        self.description = description
        self.isOptional = isOptional
    }
}

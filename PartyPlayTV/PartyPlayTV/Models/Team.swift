import Foundation

/// Represents a team grouping multiple players together.
public struct Team: Identifiable, Codable, Equatable, Hashable {
    public let id: String
    public var name: String
    public var colorHex: String
    public var playerIds: [String]
    
    public init(id: String = UUID().uuidString, name: String, colorHex: String, playerIds: [String] = []) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.playerIds = playerIds
    }
}

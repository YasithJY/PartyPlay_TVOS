import Foundation

/// Represents a participating player in a game session.
public struct Player: Identifiable, Codable, Equatable, Hashable {
    public let id: String
    public var name: String
    public var avatarSymbol: String
    public var avatarColorHex: String
    public var isSimulated: Bool
    public var isReady: Bool
    public var isHost: Bool
    public var teamId: String?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        avatarSymbol: String = "person.crop.circle.fill",
        avatarColorHex: String = "#7C4DFF",
        isSimulated: Bool = false,
        isReady: Bool = true,
        isHost: Bool = false,
        teamId: String? = nil
    ) {
        self.id = id
        self.name = name
        self.avatarSymbol = avatarSymbol
        self.avatarColorHex = avatarColorHex
        self.isSimulated = isSimulated
        self.isReady = isReady
        self.isHost = isHost
        self.teamId = teamId
    }
}

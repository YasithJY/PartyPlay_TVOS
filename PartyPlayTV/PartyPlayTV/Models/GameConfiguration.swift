import Foundation

/// Game mode archetype distinguishing gameplay formats.
public enum GamePlayMode: String, CaseIterable, Codable, Identifiable {
    case soloDemo = "Solo Host Play"
    case simulatedParty = "Simulated Party (Bots)"
    case companionParty = "Companion Phone Party"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .soloDemo:
            return "tv"
        case .simulatedParty:
            return "person.3.sequence.fill"
        case .companionParty:
            return "iphone.and.arrow.forward"
        }
    }
}

/// User-configurable settings for launching a quiz session.
public struct GameConfiguration: Codable, Equatable, Hashable {
    public var category: QuizCategory
    public var difficulty: DifficultyLevel
    public var questionCount: Int
    public var questionTimerSeconds: Int
    public var playMode: GamePlayMode
    public var simulatedPlayerCount: Int
    public var isTimeBonusEnabled: Bool
    
    public init(
        category: QuizCategory = .generalKnowledge,
        difficulty: DifficultyLevel = .all,
        questionCount: Int = 5,
        questionTimerSeconds: Int = 15,
        playMode: GamePlayMode = .soloDemo,
        simulatedPlayerCount: Int = 3,
        isTimeBonusEnabled: Bool = true
    ) {
        self.category = category
        self.difficulty = difficulty
        self.questionCount = questionCount
        self.questionTimerSeconds = questionTimerSeconds
        self.playMode = playMode
        self.simulatedPlayerCount = simulatedPlayerCount
        self.isTimeBonusEnabled = isTimeBonusEnabled
    }
    
    /// Sensible default preset for quick matches
    public static var defaultConfiguration: GameConfiguration {
        GameConfiguration()
    }
}

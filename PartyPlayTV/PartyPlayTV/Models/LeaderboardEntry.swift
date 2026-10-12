import Foundation

/// Individual ranking entry for the leaderboard and winner podium.
public struct LeaderboardEntry: Identifiable, Codable, Equatable {
    public let id: String
    public let player: Player
    public let totalScore: Int
    public let correctAnswersCount: Int
    public let totalQuestionsCount: Int
    public let rank: Int
    
    public var accuracyPercentage: Double {
        guard totalQuestionsCount > 0 else { return 0.0 }
        return (Double(correctAnswersCount) / Double(totalQuestionsCount)) * 100.0
    }
    
    public init(
        player: Player,
        totalScore: Int,
        correctAnswersCount: Int,
        totalQuestionsCount: Int,
        rank: Int
    ) {
        self.id = player.id
        self.player = player
        self.totalScore = totalScore
        self.correctAnswersCount = correctAnswersCount
        self.totalQuestionsCount = totalQuestionsCount
        self.rank = rank
    }
}

/// Comprehensive summary of a completed game session saved in history.
public struct GameResult: Identifiable, Codable, Equatable {
    public let id: String
    public let date: Date
    public let category: QuizCategory
    public let difficulty: DifficultyLevel
    public let totalQuestions: Int
    public let leaderboard: [LeaderboardEntry]
    public let winnerName: String
    public let winningScore: Int
    
    public init(
        id: String = UUID().uuidString,
        date: Date = Date(),
        category: QuizCategory,
        difficulty: DifficultyLevel,
        totalQuestions: Int,
        leaderboard: [LeaderboardEntry],
        winnerName: String,
        winningScore: Int
    ) {
        self.id = id
        self.date = date
        self.category = category
        self.difficulty = difficulty
        self.totalQuestions = totalQuestions
        self.leaderboard = leaderboard
        self.winnerName = winnerName
        self.winningScore = winningScore
    }
}

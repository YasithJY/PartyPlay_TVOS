import Foundation

/// Records a specific player's answer submission for a given question.
public struct PlayerAnswer: Codable, Equatable, Hashable {
    public let playerId: String
    public let questionId: String
    public let selectedOptionId: String?
    public let responseTimeRemaining: TimeInterval
    public let isCorrect: Bool
    public let scoreAwarded: Int
    
    public init(
        playerId: String,
        questionId: String,
        selectedOptionId: String?,
        responseTimeRemaining: TimeInterval,
        isCorrect: Bool,
        scoreAwarded: Int
    ) {
        self.playerId = playerId
        self.questionId = questionId
        self.selectedOptionId = selectedOptionId
        self.responseTimeRemaining = responseTimeRemaining
        self.isCorrect = isCorrect
        self.scoreAwarded = scoreAwarded
    }
}

/// Aggregated breakdown of results for a completed question.
public struct QuestionResult: Codable, Equatable {
    public let question: QuizQuestion
    public let playerAnswers: [PlayerAnswer]
    
    public init(question: QuizQuestion, playerAnswers: [PlayerAnswer]) {
        self.question = question
        self.playerAnswers = playerAnswers
    }
}

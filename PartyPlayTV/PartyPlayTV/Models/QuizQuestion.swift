import Foundation

/// Represents a single answer option for a quiz question.
public struct AnswerOption: Identifiable, Codable, Equatable, Hashable {
    public let id: String
    public let text: String
    
    public init(id: String, text: String) {
        self.id = id
        self.text = text
    }
}

/// Represents an individual quiz question bundled or parsed from JSON.
public struct QuizQuestion: Identifiable, Codable, Equatable, Hashable {
    public let id: String
    public let questionText: String
    public let options: [AnswerOption]
    public let correctAnswerId: String
    public let category: QuizCategory
    public let difficulty: DifficultyLevel
    public let explanation: String
    public let source: String?
    
    public init(
        id: String,
        questionText: String,
        options: [AnswerOption],
        correctAnswerId: String,
        category: QuizCategory,
        difficulty: DifficultyLevel,
        explanation: String,
        source: String? = nil
    ) {
        self.id = id
        self.questionText = questionText
        self.options = options
        self.correctAnswerId = correctAnswerId
        self.category = category
        self.difficulty = difficulty
        self.explanation = explanation
        self.source = source
    }
    
    /// Helper to find the option matching the correct answer identifier.
    public var correctOption: AnswerOption? {
        options.first { $0.id == correctAnswerId }
    }
}

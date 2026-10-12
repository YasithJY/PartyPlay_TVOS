import Foundation

/// Active session state representation containing participants, questions, and accumulated results.
public struct GameSession: Identifiable, Codable {
    public let id: String
    public let configuration: GameConfiguration
    public let roomCode: String
    public var players: [Player]
    public var questions: [QuizQuestion]
    public var currentQuestionIndex: Int
    public var questionResults: [QuestionResult]
    public var playerScores: [String: Int]
    public var isCompleted: Bool
    
    public init(
        id: String = UUID().uuidString,
        configuration: GameConfiguration,
        roomCode: String,
        players: [Player],
        questions: [QuizQuestion],
        currentQuestionIndex: Int = 0,
        questionResults: [QuestionResult] = [],
        playerScores: [String: Int] = [:],
        isCompleted: Bool = false
    ) {
        self.id = id
        self.configuration = configuration
        self.roomCode = roomCode
        self.players = players
        self.questions = questions
        self.currentQuestionIndex = currentQuestionIndex
        self.questionResults = questionResults
        self.playerScores = playerScores
        self.isCompleted = isCompleted
    }
    
    public var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex >= 0 && currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    public var totalQuestions: Int {
        questions.count
    }
    
    public var isLastQuestion: Bool {
        currentQuestionIndex >= questions.count - 1
    }
}

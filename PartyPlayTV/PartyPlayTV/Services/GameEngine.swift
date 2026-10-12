import Foundation
import Combine

/// Core GameEngine managing quiz question progression, Siri Remote answer validations, timers, and scoring.
public final class GameEngine: ObservableObject {
    @Published public private(set) var session: GameSession?
    @Published public private(set) var currentQuestion: QuizQuestion?
    @Published public private(set) var currentQuestionIndex: Int = 0
    @Published public private(set) var totalQuestions: Int = 0
    @Published public private(set) var timeRemaining: TimeInterval = 15
    @Published public private(set) var isTimerRunning: Bool = false
    @Published public private(set) var isAnswerSubmitted: Bool = false
    @Published public private(set) var selectedOptionId: String?
    @Published public private(set) var hostScore: Int = 0
    @Published public private(set) var isQuestionCompleted: Bool = false
    @Published public private(set) var finalLeaderboard: [LeaderboardEntry] = []
    @Published public private(set) var lastSavedGameResult: GameResult?
    
    private var timerCancellable: AnyCancellable?
    private let quizDataService: QuizDataService
    private let persistenceService: PersistenceServiceProtocol
    
    public init(
        quizDataService: QuizDataService = .shared,
        persistenceService: PersistenceServiceProtocol = PersistenceService.shared
    ) {
        self.quizDataService = quizDataService
        self.persistenceService = persistenceService
    }
    
    // MARK: - Game Lifecycle
    
    /// Starts a new game session with the given configuration and players.
    public func startNewGame(configuration: GameConfiguration, roomCode: String, players: [Player]) {
        // Reset state cleanly to avoid stale sessions
        stopTimer()
        
        let questions = quizDataService.fetchQuestions(
            category: configuration.category,
            difficulty: configuration.difficulty,
            count: configuration.questionCount
        )
        
        var initialScores: [String: Int] = [:]
        for player in players {
            initialScores[player.id] = 0
        }
        
        let newSession = GameSession(
            configuration: configuration,
            roomCode: roomCode,
            players: players,
            questions: questions,
            currentQuestionIndex: 0,
            questionResults: [],
            playerScores: initialScores,
            isCompleted: false
        )
        
        self.session = newSession
        self.totalQuestions = questions.count
        self.currentQuestionIndex = 0
        self.hostScore = 0
        self.finalLeaderboard = []
        self.lastSavedGameResult = nil
        
        loadCurrentQuestion()
    }
    
    /// Loads the active question and resets the timer and submission flags.
    public func loadCurrentQuestion() {
        guard let session = session, session.currentQuestionIndex < session.questions.count else {
            finishGame()
            return
        }
        
        self.currentQuestion = session.questions[session.currentQuestionIndex]
        self.currentQuestionIndex = session.currentQuestionIndex
        self.isAnswerSubmitted = false
        self.selectedOptionId = nil
        self.isQuestionCompleted = false
        self.timeRemaining = TimeInterval(session.configuration.questionTimerSeconds)
        
        startTimer()
    }
    
    // MARK: - Timer Handling
    
    public func startTimer() {
        stopTimer()
        isTimerRunning = true
        
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 1 {
                    self.timeRemaining -= 1
                } else {
                    self.timeRemaining = 0
                    self.handleTimeExpired()
                }
            }
    }
    
    public func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        isTimerRunning = false
    }
    
    private func handleTimeExpired() {
        stopTimer()
        guard !isAnswerSubmitted else { return }
        // Auto-submit empty choice upon expiration
        submitAnswer(optionId: nil)
    }
    
    // MARK: - Answer Submission
    
    /// Submits the host player's answer from Siri Remote selection.
    public func submitAnswer(optionId: String?) {
        guard !isAnswerSubmitted, let session = session, let question = currentQuestion else {
            return
        }
        
        stopTimer()
        isAnswerSubmitted = true
        self.selectedOptionId = optionId
        
        let hostPlayer = session.players.first { $0.isHost } ?? session.players.first!
        let isCorrect = (optionId == question.correctAnswerId)
        
        let scoreAwarded = ScoreService.calculateScore(
            isCorrect: isCorrect,
            difficulty: question.difficulty,
            timeRemaining: timeRemaining,
            totalTime: TimeInterval(session.configuration.questionTimerSeconds),
            isTimeBonusEnabled: session.configuration.isTimeBonusEnabled
        )
        
        let hostAnswer = PlayerAnswer(
            playerId: hostPlayer.id,
            questionId: question.id,
            selectedOptionId: optionId,
            responseTimeRemaining: timeRemaining,
            isCorrect: isCorrect,
            scoreAwarded: scoreAwarded
        )
        
        // Simulate other players' answers in the background
        var answers: [PlayerAnswer] = [hostAnswer]
        for bot in session.players where bot.id != hostPlayer.id {
            let botAnswer = simulateBotAnswer(for: bot, question: question)
            answers.append(botAnswer)
        }
        
        let result = QuestionResult(question: question, playerAnswers: answers)
        
        // Update session state
        self.session?.questionResults.append(result)
        for answer in answers {
            self.session?.playerScores[answer.playerId, default: 0] += answer.scoreAwarded
        }
        
        self.hostScore = self.session?.playerScores[hostPlayer.id, default: 0] ?? 0
        self.isQuestionCompleted = true
    }
    
    /// Simulates a plausible response for participating bots.
    private func simulateBotAnswer(for player: Player, question: QuizQuestion) -> PlayerAnswer {
        guard let session = session else {
            return PlayerAnswer(
                playerId: player.id,
                questionId: question.id,
                selectedOptionId: nil,
                responseTimeRemaining: 0,
                isCorrect: false,
                scoreAwarded: 0
            )
        }
        
        // 70% bot accuracy rate
        let isCorrect = Double.random(in: 0...1) < 0.70
        let chosenId: String
        if isCorrect {
            chosenId = question.correctAnswerId
        } else {
            let wrongOptions = question.options.filter { $0.id != question.correctAnswerId }
            chosenId = wrongOptions.randomElement()?.id ?? question.options.first!.id
        }
        
        let botTimeRemaining = Double.random(in: 2.0...Double(session.configuration.questionTimerSeconds))
        let score = ScoreService.calculateScore(
            isCorrect: isCorrect,
            difficulty: question.difficulty,
            timeRemaining: botTimeRemaining,
            totalTime: TimeInterval(session.configuration.questionTimerSeconds),
            isTimeBonusEnabled: session.configuration.isTimeBonusEnabled
        )
        
        return PlayerAnswer(
            playerId: player.id,
            questionId: question.id,
            selectedOptionId: chosenId,
            responseTimeRemaining: botTimeRemaining,
            isCorrect: isCorrect,
            scoreAwarded: score
        )
    }
    
    // MARK: - Question Progression
    
    public func advanceToNextQuestion() {
        guard var session = session else { return }
        
        if session.currentQuestionIndex + 1 < session.questions.count {
            session.currentQuestionIndex += 1
            self.session = session
            loadCurrentQuestion()
        } else {
            finishGame()
        }
    }
    
    public func finishGame() {
        stopTimer()
        guard var session = session else { return }
        session.isCompleted = true
        self.session = session
        
        let leaderboard = ScoreService.generateLeaderboard(
            players: session.players,
            questionResults: session.questionResults,
            totalQuestionsCount: session.questions.count
        )
        self.finalLeaderboard = leaderboard
        
        let winner = leaderboard.first?.player.name ?? "Host"
        let winningScore = leaderboard.first?.totalScore ?? 0
        
        let gameResult = GameResult(
            category: session.configuration.category,
            difficulty: session.configuration.difficulty,
            totalQuestions: session.questions.count,
            leaderboard: leaderboard,
            winnerName: winner,
            winningScore: winningScore
        )
        
        self.lastSavedGameResult = gameResult
        persistenceService.saveGameResult(gameResult)
    }
    
    public func resetGame() {
        stopTimer()
        session = nil
        currentQuestion = nil
        currentQuestionIndex = 0
        totalQuestions = 0
        timeRemaining = 15
        isTimerRunning = false
        isAnswerSubmitted = false
        selectedOptionId = nil
        hostScore = 0
        isQuestionCompleted = false
        finalLeaderboard = []
        lastSavedGameResult = nil
    }
}

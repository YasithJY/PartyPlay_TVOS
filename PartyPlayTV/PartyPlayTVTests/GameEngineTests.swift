import XCTest
@testable import PartyPlayTV

final class GameEngineTests: XCTestCase {
    var engine: GameEngine!
    
    override func setUp() {
        super.setUp()
        engine = GameEngine()
    }
    
    override func tearDown() {
        engine = nil
        super.tearDown()
    }
    
    func testStartNewGameInitializesCleanState() {
        let config = GameConfiguration(
            category: .generalKnowledge,
            difficulty: .all,
            questionCount: 3,
            questionTimerSeconds: 15,
            playMode: .soloDemo
        )
        let host = Player(id: "host_test", name: "Host", isHost: true)
        
        engine.startNewGame(configuration: config, roomCode: "TEST88", players: [host])
        
        XCTAssertNotNil(engine.session)
        XCTAssertEqual(engine.totalQuestions, 3)
        XCTAssertEqual(engine.currentQuestionIndex, 0)
        XCTAssertEqual(engine.hostScore, 0)
        XCTAssertFalse(engine.isAnswerSubmitted)
        XCTAssertTrue(engine.isTimerRunning)
    }
    
    func testSubmitAnswerPreventsDuplicateSubmissions() {
        let config = GameConfiguration(category: .gaming, questionCount: 2)
        let host = Player(id: "host_test", name: "Host", isHost: true)
        
        engine.startNewGame(configuration: config, roomCode: "TEST88", players: [host])
        
        guard let question = engine.currentQuestion else {
            XCTFail("Question should not be nil")
            return
        }
        
        // Submit first time
        engine.submitAnswer(optionId: question.correctAnswerId)
        XCTAssertTrue(engine.isAnswerSubmitted)
        let initialScore = engine.hostScore
        XCTAssertGreaterThan(initialScore, 0)
        
        // Attempt duplicate submission
        engine.submitAnswer(optionId: "X")
        XCTAssertEqual(engine.hostScore, initialScore, "Host score should not change on duplicate submission")
    }
    
    func testGameAdvancementAndCompletion() {
        let config = GameConfiguration(category: .sriLanka, questionCount: 2)
        let host = Player(id: "host_test", name: "Host", isHost: true)
        
        engine.startNewGame(configuration: config, roomCode: "SL1996", players: [host])
        
        // Answer question 1
        engine.submitAnswer(optionId: engine.currentQuestion?.correctAnswerId)
        engine.advanceToNextQuestion()
        
        XCTAssertEqual(engine.currentQuestionIndex, 1)
        XCTAssertFalse(engine.isAnswerSubmitted)
        
        // Answer question 2
        engine.submitAnswer(optionId: engine.currentQuestion?.correctAnswerId)
        engine.advanceToNextQuestion()
        
        XCTAssertTrue(engine.session?.isCompleted ?? false, "Session should be completed after answering all questions")
        XCTAssertFalse(engine.finalLeaderboard.isEmpty, "Final leaderboard must be populated")
    }
}

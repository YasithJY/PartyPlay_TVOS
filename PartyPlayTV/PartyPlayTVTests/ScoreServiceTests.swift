import XCTest
@testable import PartyPlayTV

final class ScoreServiceTests: XCTestCase {
    
    func testCorrectAnswerAwardsBasePoints() {
        let score = ScoreService.calculateScore(
            isCorrect: true,
            difficulty: .easy,
            timeRemaining: 0,
            totalTime: 15,
            isTimeBonusEnabled: false
        )
        XCTAssertEqual(score, 100, "Easy correct answer should award 100 base points without speed bonus")
    }
    
    func testIncorrectAnswerAwardsZeroPoints() {
        let score = ScoreService.calculateScore(
            isCorrect: false,
            difficulty: .hard,
            timeRemaining: 14,
            totalTime: 15,
            isTimeBonusEnabled: true
        )
        XCTAssertEqual(score, 0, "Incorrect answer must always award 0 points")
    }
    
    func testRapidAnswerAwardsSpeedBonus() {
        let scoreWithBonus = ScoreService.calculateScore(
            isCorrect: true,
            difficulty: .medium, // base = 200
            timeRemaining: 15,    // 100% time remaining -> 50% extra = 100 bonus
            totalTime: 15,
            isTimeBonusEnabled: true
        )
        XCTAssertEqual(scoreWithBonus, 300, "Medium question answered instantly should earn 200 base + 100 speed bonus")
    }
    
    func testLeaderboardOrderingAndTieResolution() {
        let player1 = Player(id: "p1", name: "Player One")
        let player2 = Player(id: "p2", name: "Player Two")
        
        let dummyQuestion = QuizQuestion(
            id: "q1",
            questionText: "Sample",
            options: [AnswerOption(id: "A", text: "A"), AnswerOption(id: "B", text: "B")],
            correctAnswerId: "A",
            category: .generalKnowledge,
            difficulty: .easy,
            explanation: "Sample"
        )
        
        let answerP1 = PlayerAnswer(playerId: "p1", questionId: "q1", selectedOptionId: "A", responseTimeRemaining: 10, isCorrect: true, scoreAwarded: 150)
        let answerP2 = PlayerAnswer(playerId: "p2", questionId: "q1", selectedOptionId: "B", responseTimeRemaining: 5, isCorrect: false, scoreAwarded: 0)
        
        let qr = QuestionResult(question: dummyQuestion, playerAnswers: [answerP1, answerP2])
        
        let leaderboard = ScoreService.generateLeaderboard(
            players: [player1, player2],
            questionResults: [qr],
            totalQuestionsCount: 1
        )
        
        XCTAssertEqual(leaderboard.count, 2)
        XCTAssertEqual(leaderboard.first?.player.id, "p1", "Higher scoring player must be ranked first")
        XCTAssertEqual(leaderboard.first?.rank, 1)
        XCTAssertEqual(leaderboard.last?.rank, 2)
    }
}

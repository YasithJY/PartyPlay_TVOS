import XCTest
@testable import PartyPlayTV

final class QuizDataServiceTests: XCTestCase {
    var service: QuizDataService!
    
    override func setUp() {
        super.setUp()
        service = QuizDataService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    func testBundledQuestionsLoadedSuccessfully() {
        XCTAssertGreaterThan(service.loadedQuestionsCount, 0, "Quiz questions should be loaded into memory")
    }
    
    func testFetchQuestionsByCategory() {
        let questions = service.fetchQuestions(category: .generalKnowledge, difficulty: .all, count: 3)
        XCTAssertEqual(questions.count, 3)
        for q in questions {
            XCTAssertEqual(q.category, .generalKnowledge)
        }
    }
    
    func testSriLankaQuizCategoryLoaded() {
        let questions = service.fetchQuestions(category: .sriLanka, difficulty: .all, count: 5)
        XCTAssertGreaterThan(questions.count, 0)
        XCTAssertEqual(questions.first?.category, .sriLanka)
    }
    
    func testQuestionDataIntegrity() {
        let questions = service.fetchQuestions(category: .scienceTech, difficulty: .all, count: 5)
        for q in questions {
            XCTAssertFalse(q.questionText.isEmpty, "Question text must not be empty")
            XCTAssertGreaterThanOrEqual(q.options.count, 2, "Options count must be at least 2")
            XCTAssertTrue(q.options.contains(where: { $0.id == q.correctAnswerId }), "Correct option ID must exist in options")
        }
    }
}

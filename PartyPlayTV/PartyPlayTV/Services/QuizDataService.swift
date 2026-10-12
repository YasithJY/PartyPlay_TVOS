import Foundation

/// Service responsible for loading, validating, and filtering bundled trivia questions.
public final class QuizDataService {
    public static let shared = QuizDataService()
    
    private var allQuestions: [QuizQuestion] = []
    
    public init() {
        loadBundledQuestions()
    }
    
    /// Loads questions from the main bundle or local file system fallback.
    public func loadBundledQuestions() {
        // Try Bundle.main first
        if let bundleURL = Bundle.main.url(forResource: "QuizQuestions", withExtension: "json") {
            if let questions = decodeQuestions(from: bundleURL) {
                self.allQuestions = questions
                return
            }
        }
        
        // Secondary fallback for unit test bundles
        let testBundle = Bundle(for: QuizDataService.self)
        if let testURL = testBundle.url(forResource: "QuizQuestions", withExtension: "json") {
            if let questions = decodeQuestions(from: testURL) {
                self.allQuestions = questions
                return
            }
        }
        
        // If all else fails, load embedded default backup to prevent any empty runtime state
        self.allQuestions = defaultFallbackQuestions
    }
    
    /// Decodes questions from a specified URL and validates that every correct answer exists in options.
    public func decodeQuestions(from url: URL) -> [QuizQuestion]? {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let questions = try decoder.decode([QuizQuestion].self, from: data)
            
            // Validate data integrity
            let validated = questions.filter { q in
                !q.questionText.isEmpty &&
                q.options.count >= 2 &&
                q.options.contains { $0.id == q.correctAnswerId }
            }
            return validated
        } catch {
            print("[QuizDataService] Error decoding questions: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Returns filtered and randomized questions matching game configuration criteria.
    public func fetchQuestions(
        category: QuizCategory,
        difficulty: DifficultyLevel,
        count: Int
    ) -> [QuizQuestion] {
        var pool = allQuestions.filter { $0.category == category }
        
        if difficulty != .all {
            let difficultyFiltered = pool.filter { $0.difficulty == difficulty }
            if !difficultyFiltered.isEmpty {
                pool = difficultyFiltered
            }
        }
        
        // Shuffle pool for varied gameplay
        let shuffled = pool.shuffled()
        let requestedCount = min(count, shuffled.count)
        
        if requestedCount == 0 {
            // Provide at least one fallback question to avoid zero division/crashes
            return [defaultFallbackQuestions.first!]
        }
        
        return Array(shuffled.prefix(requestedCount))
    }
    
    /// Total count of loaded questions in memory.
    public var loadedQuestionsCount: Int {
        allQuestions.count
    }
    
    /// Fallback in-memory questions guaranteed to always be available.
    private var defaultFallbackQuestions: [QuizQuestion] {
        [
            QuizQuestion(
                id: "fb_001",
                questionText: "Which ancient rock fortress in Sri Lanka was built by King Kashyapa in the 5th century?",
                options: [
                    AnswerOption(id: "A", text: "Yapahuwa"),
                    AnswerOption(id: "B", text: "Sigiriya"),
                    AnswerOption(id: "C", text: "Dambulla"),
                    AnswerOption(id: "D", text: "Ritigala")
                ],
                correctAnswerId: "B",
                category: .sriLanka,
                difficulty: .easy,
                explanation: "Sigiriya is a UNESCO World Heritage site renowned for its sheer granite summit palace.",
                source: "Sri Lanka Heritage"
            ),
            QuizQuestion(
                id: "fb_002",
                questionText: "What modern programming language was designed by Apple and launched in 2014?",
                options: [
                    AnswerOption(id: "A", text: "Kotlin"),
                    AnswerOption(id: "B", text: "Rust"),
                    AnswerOption(id: "C", text: "Swift"),
                    AnswerOption(id: "D", text: "Go")
                ],
                correctAnswerId: "C",
                category: .scienceTech,
                difficulty: .easy,
                explanation: "Apple introduced Swift at WWDC 2014 as the modern successor to Objective-C.",
                source: "Apple Developer"
            )
        ]
    }
}

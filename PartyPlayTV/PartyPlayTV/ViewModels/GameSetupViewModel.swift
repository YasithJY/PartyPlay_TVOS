import SwiftUI

/// ViewModel for configuring game session parameters before match launch.
public final class GameSetupViewModel: ObservableObject {
    @Published public var category: QuizCategory
    @Published public var difficulty: DifficultyLevel = .all
    @Published public var questionCount: Int = 5
    @Published public var questionTimerSeconds: Int = 15
    @Published public var playMode: GamePlayMode = .soloDemo
    @Published public var simulatedPlayerCount: Int = 3
    @Published public var isTimeBonusEnabled: Bool = true
    
    public let allowedQuestionCounts = [3, 5, 8, 10]
    public let allowedTimerDurations = [10, 15, 20, 30]
    
    public init(category: QuizCategory, appSettings: AppSettings = AppSettings.default) {
        self.category = category
        self.questionCount = appSettings.defaultQuestionCount
        self.questionTimerSeconds = appSettings.defaultTimerSeconds
    }
    
    public func buildConfiguration() -> GameConfiguration {
        GameConfiguration(
            category: category,
            difficulty: difficulty,
            questionCount: questionCount,
            questionTimerSeconds: questionTimerSeconds,
            playMode: playMode,
            simulatedPlayerCount: simulatedPlayerCount,
            isTimeBonusEnabled: isTimeBonusEnabled
        )
    }
}

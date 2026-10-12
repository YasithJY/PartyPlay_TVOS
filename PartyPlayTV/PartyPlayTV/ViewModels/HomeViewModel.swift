import SwiftUI

/// Central navigation coordinator paths for NavigationStack.
public enum AppRoute: Hashable {
    case gameModes
    case gameSetup(QuizCategory)
    case lobby(GameConfiguration)
    case gameplay
    case leaderboard
    case joinGame
    case howToPlay
    case settings
}

/// Primary ViewModel for the Home screen.
public final class HomeViewModel: ObservableObject {
    @Published public var recentGameResult: GameResult?
    @Published public var featuredCategories: [QuizCategory] = [
        .generalKnowledge,
        .sriLanka,
        .scienceTech,
        .gaming
    ]
    
    private let persistenceService: PersistenceServiceProtocol
    
    public init(persistenceService: PersistenceServiceProtocol = PersistenceService.shared) {
        self.persistenceService = persistenceService
        loadRecentGame()
    }
    
    public func loadRecentGame() {
        let history = persistenceService.loadGameHistory()
        self.recentGameResult = history.first
    }
}

import Foundation
import Combine

/// Root Dependency Injection Container managing application-wide singletons.
public final class AppContainer: ObservableObject {
    public static let shared = AppContainer()
    
    public let quizDataService: QuizDataService
    public let persistenceService: PersistenceServiceProtocol
    public let gameRoomService: LocalDemoRoomService
    public let gameEngine: GameEngine
    public let qrCodeService: QRCodeService
    
    @Published public var settings: AppSettings
    
    public init(
        quizDataService: QuizDataService = .shared,
        persistenceService: PersistenceServiceProtocol = PersistenceService.shared,
        gameRoomService: LocalDemoRoomService = LocalDemoRoomService(),
        qrCodeService: QRCodeService = .shared
    ) {
        self.quizDataService = quizDataService
        self.persistenceService = persistenceService
        self.gameRoomService = gameRoomService
        self.qrCodeService = qrCodeService
        self.gameEngine = GameEngine(
            quizDataService: quizDataService,
            persistenceService: persistenceService
        )
        self.settings = persistenceService.loadSettings()
    }
    
    public func updateSettings(_ newSettings: AppSettings) {
        self.settings = newSettings
        self.persistenceService.saveSettings(newSettings)
    }
}

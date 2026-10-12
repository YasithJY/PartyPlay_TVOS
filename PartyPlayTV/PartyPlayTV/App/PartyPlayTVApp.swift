import SwiftUI

/// Main tvOS application entry point configuring dependency container and root navigation stack.
@main
struct PartyPlayTVApp: App {
    @StateObject private var container = AppContainer.shared
    @State private var navigationPath: [AppRoute] = []
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                HomeView(onNavigate: { route in
                    navigationPath.append(route)
                })
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .gameModes:
                        GameModeSelectionView(
                            onSelectCategory: { category in
                                navigationPath.append(.gameSetup(category))
                            },
                            onBack: {
                                if !navigationPath.isEmpty { navigationPath.removeLast() }
                            }
                        )
                        
                    case .gameSetup(let category):
                        GameSetupView(
                            category: category,
                            appSettings: container.settings,
                            onProceedToLobby: { config in
                                navigationPath.append(.lobby(config))
                            },
                            onBack: {
                                if !navigationPath.isEmpty { navigationPath.removeLast() }
                            }
                        )
                        
                    case .lobby(let config):
                        GameLobbyView(
                            configuration: config,
                            roomService: container.gameRoomService,
                            qrCodeService: container.qrCodeService,
                            onStartGame: { players in
                                container.gameEngine.startNewGame(
                                    configuration: config,
                                    roomCode: container.gameRoomService.roomCode,
                                    players: players
                                )
                                navigationPath.append(.gameplay)
                            },
                            onBack: {
                                if !navigationPath.isEmpty { navigationPath.removeLast() }
                            }
                        )
                        
                    case .gameplay:
                        QuizGameplayView(
                            gameEngine: container.gameEngine,
                            onGameFinished: {
                                navigationPath.append(.leaderboard)
                            },
                            onLeaveGame: {
                                container.gameEngine.resetGame()
                                navigationPath.removeAll()
                            }
                        )
                        .navigationBarBackButtonHidden(true)
                        
                    case .leaderboard:
                        LeaderboardView(
                            gameEngine: container.gameEngine,
                            onPlayAgain: {
                                if let config = container.gameEngine.session?.configuration {
                                    container.gameEngine.startNewGame(
                                        configuration: config,
                                        roomCode: container.gameRoomService.roomCode,
                                        players: container.gameRoomService.players
                                    )
                                    // Pop leaderboard to return to fresh gameplay
                                    if !navigationPath.isEmpty { navigationPath.removeLast() }
                                } else {
                                    navigationPath.removeAll()
                                }
                            },
                            onReturnHome: {
                                container.gameEngine.resetGame()
                                navigationPath.removeAll()
                            }
                        )
                        .navigationBarBackButtonHidden(true)
                        
                    case .joinGame:
                        JoinGameView(onBack: {
                            if !navigationPath.isEmpty { navigationPath.removeLast() }
                        })
                        
                    case .howToPlay:
                        HowToPlayView(onBack: {
                            if !navigationPath.isEmpty { navigationPath.removeLast() }
                        })
                        
                    case .settings:
                        SettingsView(onBack: {
                            if !navigationPath.isEmpty { navigationPath.removeLast() }
                        })
                    }
                }
            }
            .environmentObject(container)
        }
    }
}

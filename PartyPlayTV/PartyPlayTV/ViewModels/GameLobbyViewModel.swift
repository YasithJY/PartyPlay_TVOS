import SwiftUI
import Combine

/// ViewModel managing the lobby state, room codes, bot simulations, and game launch.
public final class GameLobbyViewModel: ObservableObject {
    @Published public var roomCode: String = ""
    @Published public var players: [Player] = []
    @Published public var qrCodeImage: Image?
    @Published public var isReadyToStart: Bool = true
    
    public let configuration: GameConfiguration
    private let roomService: LocalDemoRoomService
    private let qrCodeService: QRCodeService
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        configuration: GameConfiguration,
        roomService: LocalDemoRoomService,
        qrCodeService: QRCodeService = .shared
    ) {
        self.configuration = configuration
        self.roomService = roomService
        self.qrCodeService = qrCodeService
        
        bindRoomService()
        setupSimulatedPlayers()
        generateLobbyQRCode()
    }
    
    private func bindRoomService() {
        roomService.$roomCode
            .sink { [weak self] code in
                self?.roomCode = code
                self?.generateLobbyQRCode()
            }
            .store(in: &cancellables)
        
        roomService.$players
            .sink { [weak self] currentPlayers in
                self?.players = currentPlayers
                self?.isReadyToStart = !currentPlayers.isEmpty
            }
            .store(in: &cancellables)
    }
    
    private func setupSimulatedPlayers() {
        if configuration.playMode == .simulatedParty {
            for _ in 0..<configuration.simulatedPlayerCount {
                roomService.simulateBotJoining()
            }
        }
    }
    
    public func addBot() {
        roomService.simulateBotJoining()
    }
    
    public func removePlayer(id: String) {
        roomService.removePlayer(id: id)
    }
    
    private func generateLobbyQRCode() {
        let joinUrl = "https://partyplay.tv/join?room=\(roomCode)"
        self.qrCodeImage = qrCodeService.generateQRCode(from: joinUrl)
    }
}

import Foundation
import Combine

/// Fully functional offline room service providing simulated multi-player lobbies without internet access.
public final class LocalDemoRoomService: ObservableObject, GameRoomServiceProtocol {
    @Published public private(set) var roomCode: String = ""
    @Published public private(set) var players: [Player] = []
    @Published public private(set) var isHostReady: Bool = true
    
    public var roomCodePublisher: AnyPublisher<String, Never> {
        $roomCode.eraseToAnyPublisher()
    }
    
    public var playersPublisher: AnyPublisher<[Player], Never> {
        $players.eraseToAnyPublisher()
    }
    
    public var isHostReadyPublisher: AnyPublisher<Bool, Never> {
        $isHostReady.eraseToAnyPublisher()
    }
    
    private let botNames = [
        "Kasun (Colombo)", "Nethmi (Kandy)", "Shenal (Galle)",
        "Dulan (Jaffna)", "Amaya (Negombo)", "Rohan (Matara)"
    ]
    
    private let botColors = [
        "#00E5FF", "#FF4081", "#00E676", "#FFAB00", "#7C4DFF", "#FF6D00"
    ]
    
    private let botAvatars = [
        "bolt.fill", "flame.fill", "star.fill", "sparkles", "gamecontroller.fill", "crown.fill"
    ]
    
    public init() {
        createRoom()
    }
    
    /// Generates a human-friendly 6-character room code (e.g., 'PLAY88').
    public func createRoom() {
        let letters = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        let randomCode = String((0..<6).map { _ in letters.randomElement()! })
        self.roomCode = randomCode
        
        // Always place Host Player at index 0
        let hostPlayer = Player(
            id: "host_local_tv",
            name: "Living Room Host (TV)",
            avatarSymbol: "tv.fill",
            avatarColorHex: "#7C4DFF",
            isSimulated: false,
            isReady: true,
            isHost: true
        )
        self.players = [hostPlayer]
    }
    
    public func addPlayer(name: String, isSimulated: Bool) {
        let avatarIndex = players.count % botAvatars.count
        let newPlayer = Player(
            id: UUID().uuidString,
            name: name,
            avatarSymbol: botAvatars[avatarIndex],
            avatarColorHex: botColors[avatarIndex],
            isSimulated: isSimulated,
            isReady: true,
            isHost: false
        )
        players.append(newPlayer)
    }
    
    public func removePlayer(id: String) {
        players.removeAll { $0.id == id && !$0.isHost }
    }
    
    public func togglePlayerReady(id: String) {
        if let index = players.firstIndex(where: { $0.id == id }) {
            players[index].isReady.toggle()
        }
    }
    
    public func simulateBotJoining() {
        guard players.count < 8 else { return }
        let availableNames = botNames.filter { name in !players.contains { $0.name == name } }
        let selectedName = availableNames.randomElement() ?? "Guest \(players.count)"
        addPlayer(name: selectedName, isSimulated: true)
    }
    
    public func leaveRoom() {
        players.removeAll()
        roomCode = ""
    }
}

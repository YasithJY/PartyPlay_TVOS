import Foundation
import Combine

/// Abstract interface for game room connectivity.
/// Decouples the UI and GameEngine from specific transport layers (Local Simulation, WebSockets, Multipeer).
public protocol GameRoomServiceProtocol: AnyObject {
    var roomCodePublisher: AnyPublisher<String, Never> { get }
    var playersPublisher: AnyPublisher<[Player], Never> { get }
    var isHostReadyPublisher: AnyPublisher<Bool, Never> { get }
    
    func createRoom()
    func addPlayer(name: String, isSimulated: Bool)
    func removePlayer(id: String)
    func togglePlayerReady(id: String)
    func simulateBotJoining()
    func leaveRoom()
}

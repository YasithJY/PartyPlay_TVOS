import SwiftUI

/// ViewModel for Leaderboard rankings and winner presentation.
public final class LeaderboardViewModel: ObservableObject {
    @Published public var leaderboard: [LeaderboardEntry] = []
    @Published public var winner: LeaderboardEntry?
    @Published public var runnerUp: LeaderboardEntry?
    @Published public var thirdPlace: LeaderboardEntry?
    
    public init(leaderboard: [LeaderboardEntry]) {
        self.leaderboard = leaderboard
        
        if leaderboard.count > 0 {
            self.winner = leaderboard[0]
        }
        if leaderboard.count > 1 {
            self.runnerUp = leaderboard[1]
        }
        if leaderboard.count > 2 {
            self.thirdPlace = leaderboard[2]
        }
    }
}

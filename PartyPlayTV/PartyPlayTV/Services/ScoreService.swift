import Foundation

/// Pure functional scoring engine that calculates points, bonuses, and leaderboard rankings.
public struct ScoreService {
    
    /// Calculates awarded score for a player's submission.
    /// - Parameters:
    ///   - isCorrect: Whether the selected answer matches the correct choice.
    ///   - difficulty: The question's difficulty level.
    ///   - timeRemaining: Seconds remaining on the clock when answered.
    ///   - totalTime: Total allotted seconds for the question.
    ///   - isTimeBonusEnabled: Flag indicating whether rapid answering grants bonus points.
    /// - Returns: Total score awarded (0 if incorrect).
    public static func calculateScore(
        isCorrect: Bool,
        difficulty: DifficultyLevel,
        timeRemaining: TimeInterval,
        totalTime: TimeInterval,
        isTimeBonusEnabled: Bool
    ) -> Int {
        guard isCorrect else { return 0 }
        
        let basePoints = difficulty.basePoints
        guard isTimeBonusEnabled, totalTime > 0 else { return basePoints }
        
        // Speed bonus: up to 50% extra base points for rapid submission
        let speedFraction = max(0.0, min(1.0, timeRemaining / totalTime))
        let timeBonus = Int(Double(basePoints) * 0.5 * speedFraction)
        
        return basePoints + timeBonus
    }
    
    /// Generates final leaderboard entries ordered from highest to lowest score with tie resolution.
    public static func generateLeaderboard(
        players: [Player],
        questionResults: [QuestionResult],
        totalQuestionsCount: Int
    ) -> [LeaderboardEntry] {
        var playerScores: [String: Int] = [:]
        var correctCounts: [String: Int] = [:]
        
        // Initialize for all participating players
        for player in players {
            playerScores[player.id] = 0
            correctCounts[player.id] = 0
        }
        
        // Tally results
        for qr in questionResults {
            for answer in qr.playerAnswers {
                playerScores[answer.playerId, default: 0] += answer.scoreAwarded
                if answer.isCorrect {
                    correctCounts[answer.playerId, default: 0] += 1
                }
            }
        }
        
        // Sort players: primary key = total score (descending), secondary key = correct count (descending)
        let sortedPlayers = players.sorted { p1, p2 in
            let score1 = playerScores[p1.id, default: 0]
            let score2 = playerScores[p2.id, default: 0]
            if score1 != score2 {
                return score1 > score2
            }
            return correctCounts[p1.id, default: 0] > correctCounts[p2.id, default: 0]
        }
        
        // Assign ranks with proper tie handling
        var entries: [LeaderboardEntry] = []
        var currentRank = 1
        
        for (index, player) in sortedPlayers.enumerated() {
            if index > 0 {
                let prevPlayer = sortedPlayers[index - 1]
                let prevScore = playerScores[prevPlayer.id, default: 0]
                let prevCorrect = correctCounts[prevPlayer.id, default: 0]
                
                let curScore = playerScores[player.id, default: 0]
                let curCorrect = correctCounts[player.id, default: 0]
                
                if curScore != prevScore || curCorrect != prevCorrect {
                    currentRank = index + 1
                }
            }
            
            let entry = LeaderboardEntry(
                player: player,
                totalScore: playerScores[player.id, default: 0],
                correctAnswersCount: correctCounts[player.id, default: 0],
                totalQuestionsCount: totalQuestionsCount,
                rank: currentRank
            )
            entries.append(entry)
        }
        
        return entries
    }
}

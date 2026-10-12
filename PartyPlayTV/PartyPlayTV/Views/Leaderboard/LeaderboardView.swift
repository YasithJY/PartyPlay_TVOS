import SwiftUI

/// Final Leaderboard view featuring podium presentation, rank breakdowns, play again, and return home actions.
public struct LeaderboardView: View {
    @ObservedObject var gameEngine: GameEngine
    @StateObject private var viewModel: LeaderboardViewModel
    @FocusState private var focusedField: String?
    
    private let onPlayAgain: () -> Void
    private let onReturnHome: () -> Void
    
    public init(
        gameEngine: GameEngine,
        onPlayAgain: @escaping () -> Void,
        onReturnHome: @escaping () -> Void
    ) {
        self.gameEngine = gameEngine
        _viewModel = StateObject(wrappedValue: LeaderboardViewModel(leaderboard: gameEngine.finalLeaderboard))
        self.onPlayAgain = onPlayAgain
        self.onReturnHome = onReturnHome
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: AppSpacing.large) {
                // Celebration Title Banner
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.accentGold)
                        
                        Text("FINAL GAME SHOW RESULTS")
                            .font(AppTypography.caption)
                            .tracking(4)
                            .foregroundColor(AppColors.accentGold)
                    }
                    
                    Text("Game Show Champion")
                        .font(AppTypography.heroTitle)
                        .foregroundColor(.white)
                }
                .padding(.top, AppSpacing.tvSafeMarginVertical)
                
                // Podium Presentation for Top 3
                HStack(alignment: .bottom, spacing: 32) {
                    // 2nd Place (Silver)
                    if let runnerUp = viewModel.runnerUp {
                        PodiumColumn(
                            entry: runnerUp,
                            medalTitle: "2ND PLACE",
                            medalColor: Color(red: 0.75, green: 0.75, blue: 0.75),
                            height: 180
                        )
                    }
                    
                    // 1st Place (Gold Winner)
                    if let winner = viewModel.winner {
                        PodiumColumn(
                            entry: winner,
                            medalTitle: "CHAMPION",
                            medalColor: AppColors.accentGold,
                            height: 240,
                            isWinner: true
                        )
                    }
                    
                    // 3rd Place (Bronze)
                    if let third = viewModel.thirdPlace {
                        PodiumColumn(
                            entry: third,
                            medalTitle: "3RD PLACE",
                            medalColor: Color(red: 0.80, green: 0.50, blue: 0.20),
                            height: 140
                        )
                    }
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // Detailed Rankings Table
                VStack(spacing: 12) {
                    ForEach(viewModel.leaderboard) { entry in
                        HStack(spacing: 24) {
                            Text("#\(entry.rank)")
                                .font(AppTypography.cardTitle)
                                .foregroundColor(entry.rank == 1 ? AppColors.accentGold : AppColors.textMuted)
                                .frame(width: 60, alignment: .leading)
                            
                            HStack(spacing: 14) {
                                Circle()
                                    .fill(Color(hex: entry.player.avatarColorHex))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Image(systemName: entry.player.avatarSymbol)
                                            .foregroundColor(.white)
                                    )
                                
                                Text(entry.player.name)
                                    .font(AppTypography.headline)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 32) {
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("ACCURACY")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(AppColors.textMuted)
                                    Text("\(Int(entry.accuracyPercentage))%")
                                        .font(AppTypography.body)
                                        .foregroundColor(AppColors.neonCyan)
                                }
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("CORRECT")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(AppColors.textMuted)
                                    Text("\(entry.correctAnswersCount)/\(entry.totalQuestionsCount)")
                                        .font(AppTypography.body)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("SCORE")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(AppColors.textMuted)
                                    Text("\(entry.totalScore) pts")
                                        .font(AppTypography.cardTitle)
                                        .foregroundColor(AppColors.accentGold)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 28)
                        .background(
                            RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                                        .stroke(entry.rank == 1 ? AppColors.accentGold.opacity(0.8) : AppColors.cardBorder, lineWidth: 1.5)
                                )
                        )
                    }
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // Bottom Actions
                HStack(spacing: 32) {
                    Button(action: onPlayAgain) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Play Again")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .focused($focusedField, equals: "playAgain")
                    
                    Button(action: onReturnHome) {
                        HStack(spacing: 12) {
                            Image(systemName: "house.fill")
                            Text("Return Home")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .focused($focusedField, equals: "returnHome")
                }
                .padding(.top, 16)
                .padding(.bottom, AppSpacing.tvSafeMarginVertical)
            }
        }
        .ambientGameBackground()
        .onAppear {
            if focusedField == nil {
                focusedField = "playAgain"
            }
        }
    }
}

/// Helper view for rendering podium pedestals.
private struct PodiumColumn: View {
    let entry: LeaderboardEntry
    let medalTitle: String
    let medalColor: Color
    let height: CGFloat
    var isWinner: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            PlayerAvatarView(player: entry.player, size: isWinner ? 96 : 80)
            
            Text("\(entry.totalScore) pts")
                .font(AppTypography.headline)
                .foregroundColor(medalColor)
            
            VStack {
                Text(medalTitle)
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(medalColor)
                    .tracking(2)
                    .padding(.top, 14)
                Spacer()
            }
            .frame(width: 220, height: height)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                            .stroke(medalColor, lineWidth: isWinner ? 3 : 1.5)
                    )
            )
        }
    }
}

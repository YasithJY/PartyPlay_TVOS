import SwiftUI

/// Main tvOS Home screen with hero game-show branding, quick actions, featured modes, and recent game preview.
public struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var container: AppContainer
    @FocusState private var focusedField: String?
    
    private let onNavigate: (AppRoute) -> Void
    
    public init(onNavigate: @escaping (AppRoute) -> Void) {
        self.onNavigate = onNavigate
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                // Top Hero Game Show Header
                HStack(alignment: .center, spacing: AppSpacing.large) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            Image(systemName: "sparkles.tv.fill")
                                .font(.system(size: 40))
                                .foregroundColor(AppColors.neonCyan)
                            
                            Text("PARTYPLAY TV")
                                .font(AppTypography.caption)
                                .tracking(4)
                                .foregroundColor(AppColors.neonCyan)
                        }
                        
                        Text("Your Living Room Game Show")
                            .font(AppTypography.heroTitle)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Gather your friends & family. Answer fast from the Siri Remote or connect phones!")
                            .font(AppTypography.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Quick Action Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            onNavigate(.gameModes)
                        }) {
                            HStack(spacing: 14) {
                                Image(systemName: "play.fill")
                                Text("Play Now")
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .focused($focusedField, equals: "playNow")
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                onNavigate(.joinGame)
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "qrcode")
                                    Text("Join Game")
                                }
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .focused($focusedField, equals: "joinGame")
                            
                            Button(action: {
                                onNavigate(.howToPlay)
                            }) {
                                Image(systemName: "questionmark.circle")
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .focused($focusedField, equals: "howToPlay")
                            
                            Button(action: {
                                onNavigate(.settings)
                            }) {
                                Image(systemName: "gearshape")
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .focused($focusedField, equals: "settings")
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                .padding(.top, AppSpacing.tvSafeMarginVertical)
                
                // Featured Trivia Categories Section
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    SectionHeader(
                        title: "Featured Quiz Categories",
                        subtitle: "Select a category to customize difficulty, timer, and launch a match",
                        iconName: "flame.fill"
                    )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.large) {
                            ForEach(viewModel.featuredCategories) { category in
                                GameModeCard(category: category, width: 440) {
                                    onNavigate(.gameSetup(category))
                                }
                            }
                        }
                        .padding(.vertical, AppSpacing.small)
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // Recent Match or Quick Stats Banner
                if let recent = viewModel.recentGameResult {
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(
                            title: "Latest Match Result",
                            iconName: "trophy.fill"
                        )
                        
                        HStack(spacing: AppSpacing.large) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("WINNER")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppColors.accentGold)
                                Text(recent.winnerName)
                                    .font(AppTypography.headline)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("CATEGORY")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppColors.textMuted)
                                Text(recent.category.rawValue)
                                    .font(AppTypography.cardTitle)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 6) {
                                Text("WINNING SCORE")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppColors.textMuted)
                                Text("\(recent.winningScore) pts")
                                    .font(AppTypography.scoreDigits)
                                    .foregroundColor(AppColors.accentGold)
                            }
                        }
                        .padding(AppSpacing.large)
                        .background(
                            RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                                        .stroke(AppColors.cardBorder, lineWidth: 1.5)
                                )
                        )
                    }
                    .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                    .padding(.bottom, AppSpacing.tvSafeMarginVertical)
                }
            }
        }
        .ambientGameBackground()
        .onAppear {
            viewModel.loadRecentGame()
            if focusedField == nil {
                focusedField = "playNow"
            }
        }
    }
}

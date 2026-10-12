import SwiftUI

/// Configuration screen allowing users to customize match length, timer, difficulty, and player mode.
public struct GameSetupView: View {
    @StateObject private var viewModel: GameSetupViewModel
    @FocusState private var focusedField: String?
    
    private let onProceedToLobby: (GameConfiguration) -> Void
    private let onBack: () -> Void
    
    public init(
        category: QuizCategory,
        appSettings: AppSettings,
        onProceedToLobby: @escaping (GameConfiguration) -> Void,
        onBack: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: GameSetupViewModel(category: category, appSettings: appSettings))
        self.onProceedToLobby = onProceedToLobby
        self.onBack = onBack
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                // Header
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Categories")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Game Configuration")
                            .font(AppTypography.sectionTitle)
                            .foregroundColor(.white)
                        Text(viewModel.category.rawValue)
                            .font(AppTypography.subheadline)
                            .foregroundColor(Color(hex: viewModel.category.themeHexColor))
                    }
                }
                .padding(.top, AppSpacing.tvSafeMarginVertical)
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // Form Sections Container
                VStack(spacing: AppSpacing.large) {
                    // Play Mode Selector
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: "Party Format", subtitle: "Select how participants join this match")
                        
                        HStack(spacing: 24) {
                            ForEach(GamePlayMode.allCases) { mode in
                                Button(action: { viewModel.playMode = mode }) {
                                    HStack(spacing: 14) {
                                        Image(systemName: mode.iconName)
                                            .font(.system(size: 26))
                                            .foregroundColor(viewModel.playMode == mode ? AppColors.neonCyan : .white)
                                        Text(mode.rawValue)
                                            .font(AppTypography.body)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 24)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                                            .fill(viewModel.playMode == mode ? AppColors.cardBackgroundHover : AppColors.cardBackground)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                                            .stroke(viewModel.playMode == mode ? AppColors.neonCyan : AppColors.cardBorder, lineWidth: 2)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Difficulty Selector
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: "Difficulty Level", subtitle: "Affects question complexity & base points")
                        
                        HStack(spacing: 24) {
                            ForEach(DifficultyLevel.allCases) { diff in
                                Button(action: { viewModel.difficulty = diff }) {
                                    Text(diff.badgeLabel)
                                        .font(AppTypography.body)
                                        .foregroundColor(viewModel.difficulty == diff ? AppColors.accentGold : .white)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 28)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                                                .fill(viewModel.difficulty == diff ? AppColors.cardBackgroundHover : AppColors.cardBackground)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                                                .stroke(viewModel.difficulty == diff ? AppColors.accentGold : AppColors.cardBorder, lineWidth: 2)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Question Count & Timer Selectors
                    HStack(spacing: 48) {
                        // Question Count
                        VStack(alignment: .leading, spacing: 14) {
                            SectionHeader(title: "Questions per Match")
                            HStack(spacing: 16) {
                                ForEach(viewModel.allowedQuestionCounts, id: \.self) { count in
                                    Button(action: { viewModel.questionCount = count }) {
                                        Text("\(count)")
                                            .font(AppTypography.cardTitle)
                                            .frame(width: 80, height: 60)
                                            .foregroundColor(viewModel.questionCount == count ? AppColors.neonCyan : .white)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(viewModel.questionCount == count ? AppColors.cardBackgroundHover : AppColors.cardBackground)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(viewModel.questionCount == count ? AppColors.neonCyan : AppColors.cardBorder, lineWidth: 2)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        // Timer Duration
                        VStack(alignment: .leading, spacing: 14) {
                            SectionHeader(title: "Countdown Timer")
                            HStack(spacing: 16) {
                                ForEach(viewModel.allowedTimerDurations, id: \.self) { duration in
                                    Button(action: { viewModel.questionTimerSeconds = duration }) {
                                        Text("\(duration)s")
                                            .font(AppTypography.cardTitle)
                                            .frame(width: 90, height: 60)
                                            .foregroundColor(viewModel.questionTimerSeconds == duration ? AppColors.vividBlue : .white)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(viewModel.questionTimerSeconds == duration ? AppColors.cardBackgroundHover : AppColors.cardBackground)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(viewModel.questionTimerSeconds == duration ? AppColors.vividBlue : AppColors.cardBorder, lineWidth: 2)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    
                    // Bottom Proceed Action
                    HStack {
                        Spacer()
                        Button(action: {
                            let config = viewModel.buildConfiguration()
                            onProceedToLobby(config)
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 28))
                                Text("Go to Game Lobby")
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .focused($focusedField, equals: "proceedLobby")
                        Spacer()
                    }
                    .padding(.top, AppSpacing.medium)
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                .padding(.bottom, AppSpacing.tvSafeMarginVertical)
            }
        }
        .ambientGameBackground()
        .onAppear {
            if focusedField == nil {
                focusedField = "proceedLobby"
            }
        }
    }
}

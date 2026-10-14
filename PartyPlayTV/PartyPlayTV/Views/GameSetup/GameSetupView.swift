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
            VStack(alignment: .leading, spacing: 28) {
                // Header with navigation and category badge
                HStack(alignment: .center) {
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
                VStack(spacing: 28) {
                    // 1. Play Mode Selector (Party Format)
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: "Party Format", subtitle: "Select how participants join this match")
                        
                        HStack(spacing: 20) {
                            ForEach(GamePlayMode.allCases) { mode in
                                SetupSelectableCard(
                                    isSelected: viewModel.playMode == mode,
                                    activeColor: AppColors.neonCyan
                                ) {
                                    viewModel.playMode = mode
                                } content: {
                                    HStack(spacing: 12) {
                                        Image(systemName: mode.iconName)
                                            .font(.system(size: 24))
                                            .foregroundColor(viewModel.playMode == mode ? AppColors.neonCyan : .white)
                                        Text(mode.rawValue)
                                            .font(AppTypography.body)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.85)
                                    }
                                }
                            }
                        }
                    }
                    
                    // 2. Difficulty Selector
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: "Difficulty Level", subtitle: "Affects question complexity & base points")
                        
                        HStack(spacing: 16) {
                            ForEach(DifficultyLevel.allCases) { diff in
                                SetupSelectableCard(
                                    isSelected: viewModel.difficulty == diff,
                                    activeColor: AppColors.accentGold
                                ) {
                                    viewModel.difficulty = diff
                                } content: {
                                    VStack(spacing: 4) {
                                        Text(diff.badgeLabel)
                                            .font(AppTypography.body)
                                            .fontWeight(.bold)
                                            .foregroundColor(viewModel.difficulty == diff ? AppColors.accentGold : .white)
                                            .lineLimit(1)
                                        
                                        Text("\(diff.basePoints) pts base")
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.textMuted)
                                    }
                                }
                            }
                        }
                    }
                    
                    // 3. Question Count & Timer Selectors (Balanced 2-Column Row)
                    HStack(alignment: .top, spacing: 32) {
                        // Question Count Column
                        VStack(alignment: .leading, spacing: 14) {
                            SectionHeader(title: "Questions per Match", subtitle: "Total rounds in this game show")
                            HStack(spacing: 14) {
                                ForEach(viewModel.allowedQuestionCounts, id: \.self) { count in
                                    SetupSelectableCard(
                                        isSelected: viewModel.questionCount == count,
                                        activeColor: AppColors.neonCyan
                                    ) {
                                        viewModel.questionCount = count
                                    } content: {
                                        VStack(spacing: 2) {
                                            Text("\(count)")
                                                .font(AppTypography.cardTitle)
                                                .foregroundColor(viewModel.questionCount == count ? AppColors.neonCyan : .white)
                                            Text("Qs")
                                                .font(AppTypography.caption)
                                                .foregroundColor(AppColors.textMuted)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Timer Duration Column
                        VStack(alignment: .leading, spacing: 14) {
                            SectionHeader(title: "Countdown Timer", subtitle: "Time limit per question")
                            HStack(spacing: 14) {
                                ForEach(viewModel.allowedTimerDurations, id: \.self) { duration in
                                    SetupSelectableCard(
                                        isSelected: viewModel.questionTimerSeconds == duration,
                                        activeColor: AppColors.vividBlue
                                    ) {
                                        viewModel.questionTimerSeconds = duration
                                    } content: {
                                        VStack(spacing: 2) {
                                            Text("\(duration)s")
                                                .font(AppTypography.cardTitle)
                                                .foregroundColor(viewModel.questionTimerSeconds == duration ? AppColors.vividBlue : .white)
                                            Text("Sec")
                                                .font(AppTypography.caption)
                                                .foregroundColor(AppColors.textMuted)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // 4. Live Match Configuration Summary Card
                    HStack(spacing: 24) {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .foregroundColor(Color(hex: viewModel.category.themeHexColor))
                            Text(viewModel.category.rawValue)
                                .font(AppTypography.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Text("•")
                            .foregroundColor(AppColors.cardBorder)
                        
                        HStack(spacing: 8) {
                            Image(systemName: viewModel.playMode.iconName)
                                .foregroundColor(AppColors.neonCyan)
                            Text(viewModel.playMode.rawValue)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Text("•")
                            .foregroundColor(AppColors.cardBorder)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(AppColors.accentGold)
                            Text("\(viewModel.difficulty.rawValue) (\(viewModel.difficulty.basePoints) pts)")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(AppColors.vividBlue)
                            Text("\(viewModel.questionCount) Questions • \(viewModel.questionTimerSeconds)s each")
                                .font(AppTypography.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                            .fill(AppColors.cardBackground.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                                    .stroke(AppColors.cardBorder.opacity(0.6), lineWidth: 1.5)
                            )
                    )
                    
                    // 5. Bottom Proceed Action
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
                    .padding(.top, 4)
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

/// Dedicated focusable option card eliminating tvOS white halo overlay and preventing button overlap.
private struct SetupSelectableCard<Content: View>: View {
    @Environment(\.isFocused) private var isEnvironmentFocused: Bool
    @FocusState private var isSelfFocused: Bool
    
    private var isFocused: Bool {
        isEnvironmentFocused || isSelfFocused
    }
    
    let isSelected: Bool
    let activeColor: Color
    let action: () -> Void
    let content: Content
    
    init(
        isSelected: Bool,
        activeColor: Color = AppColors.neonCyan,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isSelected = isSelected
        self.activeColor = activeColor
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: action) {
            content
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                        .fill(isSelected ? activeColor.opacity(0.2) : (isFocused ? AppColors.cardBackgroundHover : AppColors.cardBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                        .stroke(
                            isFocused ? AppColors.neonCyan : (isSelected ? activeColor : AppColors.cardBorder.opacity(0.6)),
                            lineWidth: isFocused ? 3.5 : (isSelected ? 2.0 : 1.2)
                        )
                )
                .shadow(
                    color: isFocused ? AppColors.neonCyan.opacity(0.4) : (isSelected ? activeColor.opacity(0.2) : Color.black.opacity(0.15)),
                    radius: isFocused ? 16 : 4,
                    x: 0,
                    y: isFocused ? 6 : 2
                )
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
        .focused($isSelfFocused)
        .scaleEffect(isFocused ? 1.03 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

import SwiftUI

/// Primary tvOS gameplay screen with questions, animated timer, answer options, and immediate feedback reveal.
public struct QuizGameplayView: View {
    @ObservedObject var gameEngine: GameEngine
    @FocusState private var focusedOptionIndex: Int?
    @State private var autoAdvanceTask: DispatchWorkItem?
    
    private let onGameFinished: () -> Void
    private let onLeaveGame: () -> Void
    
    public init(
        gameEngine: GameEngine,
        onGameFinished: @escaping () -> Void,
        onLeaveGame: @escaping () -> Void
    ) {
        self.gameEngine = gameEngine
        self.onGameFinished = onGameFinished
        self.onLeaveGame = onLeaveGame
    }
    
    private let optionLetters = ["A", "B", "C", "D"]
    
    public var body: some View {
        ZStack {
            if let question = gameEngine.currentQuestion {
                VStack(spacing: AppSpacing.large) {
                    // Top Status Bar: Category, Question Number, Countdown Timer & Current Score
                    HStack(alignment: .center) {
                        // Category & Progress
                        VStack(alignment: .leading, spacing: 4) {
                            Text(question.category.rawValue.uppercased())
                                .font(.system(size: 16, weight: .bold))
                                .tracking(3)
                                .foregroundColor(Color(hex: question.category.themeHexColor))
                            
                            HStack(spacing: 8) {
                                Text("QUESTION")
                                    .font(AppTypography.subheadline)
                                    .foregroundColor(AppColors.textMuted)
                                Text("\(gameEngine.currentQuestionIndex + 1) of \(gameEngine.totalQuestions)")
                                    .font(AppTypography.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        // Centered Countdown Timer
                        CountdownView(
                            timeRemaining: gameEngine.timeRemaining,
                            totalTime: TimeInterval(gameEngine.session?.configuration.questionTimerSeconds ?? 15)
                        )
                        
                        Spacer()
                        
                        // Current Host Score
                        ScoreBadge(score: gameEngine.hostScore)
                    }
                    .padding(.top, AppSpacing.tvSafeMarginVertical)
                    .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                    
                    // Question Prompt Display Card
                    VStack(spacing: 12) {
                        Text(question.questionText)
                            .font(AppTypography.questionPrompt)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .padding(.horizontal, 48)
                            .padding(.vertical, 32)
                            .frame(maxWidth: .infinity, minHeight: 180)
                            .background(
                                RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                                            .stroke(AppColors.cardBorder, lineWidth: 2)
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                    
                    // 2x2 Answer Option Grid
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: AppSpacing.large),
                            GridItem(.flexible(), spacing: AppSpacing.large)
                        ],
                        spacing: AppSpacing.large
                    ) {
                        ForEach(Array(question.options.enumerated()), id: \.element.id) { index, option in
                            let letter = index < optionLetters.count ? optionLetters[index] : "\(index + 1)"
                            let isSelected = (gameEngine.selectedOptionId == option.id)
                            let isCorrect = (option.id == question.correctAnswerId)
                            
                            AnswerOptionCard(
                                option: option,
                                indexLetter: letter,
                                isSelected: isSelected,
                                isAnswerSubmitted: gameEngine.isAnswerSubmitted,
                                isCorrectChoice: isCorrect
                            ) {
                                selectAnswer(option.id)
                            }
                            .focused($focusedOptionIndex, equals: index)
                        }
                    }
                    .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                    
                    // Post-Answer Explanation Banner & Controls
                    if gameEngine.isAnswerSubmitted {
                        HStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 10) {
                                    let isHostCorrect = (gameEngine.selectedOptionId == question.correctAnswerId)
                                    Image(systemName: isHostCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(isHostCorrect ? AppColors.correctGreen : AppColors.incorrectRed)
                                    
                                    Text(isHostCorrect ? "Correct Answer!" : "Incorrect!")
                                        .font(AppTypography.headline)
                                        .foregroundColor(isHostCorrect ? AppColors.correctGreen : AppColors.incorrectRed)
                                }
                                
                                Text(question.explanation)
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.textSecondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                proceedNext()
                            }) {
                                HStack(spacing: 12) {
                                    Text(gameEngine.currentQuestionIndex + 1 >= gameEngine.totalQuestions ? "View Leaderboard" : "Next Question")
                                    Image(systemName: "arrow.right")
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                                        .stroke(AppColors.neonCyan.opacity(0.8), lineWidth: 2)
                                )
                        )
                        .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Spacer()
                }
            } else {
                LoadingView(statusMessage: "Preparing Game...")
            }
        }
        .ambientGameBackground()
        .onAppear {
            focusedOptionIndex = 0
        }
        .onDisappear {
            autoAdvanceTask?.cancel()
            gameEngine.stopTimer()
        }
    }
    
    private func selectAnswer(_ optionId: String) {
        guard !gameEngine.isAnswerSubmitted else { return }
        gameEngine.submitAnswer(optionId: optionId)
        
        // Schedule auto-advancement after 5 seconds if host doesn't manually press Next
        autoAdvanceTask?.cancel()
        let task = DispatchWorkItem {
            proceedNext()
        }
        autoAdvanceTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: task)
    }
    
    private func proceedNext() {
        autoAdvanceTask?.cancel()
        if gameEngine.currentQuestionIndex + 1 < gameEngine.totalQuestions {
            gameEngine.advanceToNextQuestion()
            focusedOptionIndex = 0
        } else {
            gameEngine.finishGame()
            onGameFinished()
        }
    }
}

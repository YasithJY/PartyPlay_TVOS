import SwiftUI

/// Explanatory guide detailing game show rules, scoring policies, and Siri Remote controls.
public struct HowToPlayView: View {
    private let onBack: () -> Void
    
    public init(onBack: @escaping () -> Void) {
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
                            Text("Back")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("How to Play PartyPlay TV")
                            .font(AppTypography.sectionTitle)
                            .foregroundColor(.white)
                        Text("Rules, Siri Remote controls & scoring system")
                            .font(AppTypography.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.top, AppSpacing.tvSafeMarginVertical)
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // 3 Card Overview
                HStack(spacing: 32) {
                    GuideRuleCard(
                        iconName: "tv.and.mediabox",
                        title: "1. The Big Screen",
                        text: "The Apple TV acts as the game show host and main stage. Questions, countdown timers, and results are broadcast here for the whole room."
                    )
                    
                    GuideRuleCard(
                        iconName: "bolt.fill",
                        title: "2. Siri Remote Controls",
                        text: "Swipe on the clickpad or press arrow buttons on your Siri Remote to move focus across answers A, B, C, and D. Click the center button to lock in your answer!"
                    )
                    
                    GuideRuleCard(
                        iconName: "stopwatch.fill",
                        title: "3. Speed Matters",
                        text: "Correct answers earn base points (100–300 pts) plus up to 50% extra speed bonus for answering rapidly before the countdown expires."
                    )
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // Scoring Breakdown Card
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(
                        title: "Scoring & Points Formula",
                        iconName: "chart.bar.xaxis"
                    )
                    
                    HStack(spacing: 48) {
                        ScoreRulePill(label: "Easy Question", points: "100 pts + Bonus", color: AppColors.correctGreen)
                        ScoreRulePill(label: "Medium Question", points: "200 pts + Bonus", color: AppColors.vividBlue)
                        ScoreRulePill(label: "Hard Question", points: "300 pts + Bonus", color: AppColors.neonPink)
                        ScoreRulePill(label: "Wrong / Time Out", points: "0 pts", color: AppColors.incorrectRed)
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                        .fill(AppColors.cardBackground)
                )
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                .padding(.bottom, AppSpacing.tvSafeMarginVertical)
            }
        }
        .ambientGameBackground()
    }
}

private struct GuideRuleCard: View {
    let iconName: String
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 40))
                .foregroundColor(AppColors.neonCyan)
            
            Text(title)
                .font(AppTypography.cardTitle)
                .foregroundColor(.white)
            
            Text(text)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(4)
        }
        .padding(28)
        .frame(maxWidth: .infinity, minHeight: 240, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1.5)
                )
        )
    }
}

private struct ScoreRulePill: View {
    let label: String
    let points: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textMuted)
            Text(points)
                .font(AppTypography.body)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}

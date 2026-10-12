import SwiftUI

/// Screen presenting the complete catalog of 6 trivia categories.
public struct GameModeSelectionView: View {
    private let onSelectCategory: (QuizCategory) -> Void
    private let onBack: () -> Void
    
    public init(
        onSelectCategory: @escaping (QuizCategory) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.onSelectCategory = onSelectCategory
        self.onBack = onBack
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.large),
        GridItem(.flexible(), spacing: AppSpacing.large),
        GridItem(.flexible(), spacing: AppSpacing.large)
    ]
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                // Header with back navigation button
                HStack(alignment: .center) {
                    Button(action: onBack) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Back to Home")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Choose Quiz Category")
                            .font(AppTypography.sectionTitle)
                            .foregroundColor(.white)
                        Text("Pick a theme to challenge your party")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.top, AppSpacing.tvSafeMarginVertical)
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // 3x2 Category Grid
                LazyVGrid(columns: columns, spacing: AppSpacing.large) {
                    ForEach(QuizCategory.allCases) { category in
                        GameModeCard(category: category) {
                            onSelectCategory(category)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                .padding(.bottom, AppSpacing.tvSafeMarginVertical)
            }
        }
        .ambientGameBackground()
    }
}

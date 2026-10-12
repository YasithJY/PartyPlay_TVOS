import SwiftUI

/// Score badge displaying current game points with gold glow and icon.
public struct ScoreBadge: View {
    private let score: Int
    private let title: String
    
    public init(score: Int, title: String = "SCORE") {
        self.score = score
        self.title = title
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(AppColors.textMuted)
                .tracking(2)
            
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .font(.system(size: 22))
                    .foregroundColor(AppColors.accentGold)
                
                Text("\(score)")
                    .font(AppTypography.scoreDigits)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.badgeCornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppSpacing.badgeCornerRadius)
                        .stroke(AppColors.accentGold.opacity(0.4), lineWidth: 1.5)
                )
        )
    }
}

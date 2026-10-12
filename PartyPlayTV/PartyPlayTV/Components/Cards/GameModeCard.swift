import SwiftUI

/// Category and Game Mode selection card displaying custom theme colors and icons.
public struct GameModeCard: View {
    @FocusState private var isFocused: Bool
    
    private let category: QuizCategory
    private let isSelected: Bool
    private let action: () -> Void
    
    public init(category: QuizCategory, isSelected: Bool = false, action: @escaping () -> Void) {
        self.category = category
        self.isSelected = isSelected
        self.action = action
    }
    
    private var themeColor: Color {
        Color(hex: category.themeHexColor)
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(themeColor.opacity(0.2))
                            .frame(width: 72, height: 72)
                        
                        Image(systemName: category.iconName)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(themeColor)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(AppColors.neonCyan)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(category.rawValue)
                        .font(AppTypography.cardTitle)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(category.subtitle)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                }
            }
            .padding(24)
            .frame(width: 440, height: 260)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                    .fill(isFocused ? AppColors.cardBackgroundHover : AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                    .stroke(
                        isFocused ? AppColors.neonCyan : (isSelected ? themeColor : AppColors.cardBorder.opacity(0.6)),
                        lineWidth: (isFocused || isSelected) ? 3.5 : 1.5
                    )
            )
            .shadow(
                color: isFocused ? themeColor.opacity(0.5) : Color.black.opacity(0.25),
                radius: isFocused ? 24 : 8,
                x: 0,
                y: isFocused ? 10 : 4
            )
        }
        .buttonStyle(.plain)
        .focused($isFocused)
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.22), value: isFocused)
    }
}

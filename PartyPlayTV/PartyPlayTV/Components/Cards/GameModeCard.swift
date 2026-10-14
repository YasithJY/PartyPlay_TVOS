import SwiftUI

/// Category and Game Mode selection card displaying custom theme colors and icons.
public struct GameModeCard: View {
    @Environment(\.isFocused) private var isEnvironmentFocused: Bool
    @FocusState private var isSelfFocused: Bool
    
    private var isFocused: Bool {
        isEnvironmentFocused || isSelfFocused
    }
    
    private let category: QuizCategory
    private let isSelected: Bool
    private let width: CGFloat?
    private let action: () -> Void
    
    public init(category: QuizCategory, isSelected: Bool = false, width: CGFloat? = nil, action: @escaping () -> Void) {
        self.category = category
        self.isSelected = isSelected
        self.width = width
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
            .frame(width: width)
            .frame(maxWidth: width == nil ? .infinity : width, minHeight: 220, maxHeight: 260)
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
                radius: isFocused ? 20 : 8,
                x: 0,
                y: isFocused ? 8 : 4
            )
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
        .focused($isSelfFocused)
        .scaleEffect(isFocused ? 1.03 : 1.0)
        .animation(.easeInOut(duration: 0.22), value: isFocused)
    }
}

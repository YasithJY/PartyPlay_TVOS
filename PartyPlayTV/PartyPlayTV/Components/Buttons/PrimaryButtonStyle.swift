import SwiftUI

/// tvOS primary button style with interactive focus scaling and brand lighting.
public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isFocused) private var isFocused: Bool
    
    private let backgroundColor: Color
    private let foregroundColor: Color
    
    public init(
        backgroundColor: Color = AppColors.electricPurple,
        foregroundColor: Color = .white
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.subheadline)
            .fontWeight(.bold)
            .foregroundColor(foregroundColor)
            .padding(.vertical, 18)
            .padding(.horizontal, 36)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                    .fill(isFocused ? AppColors.vividBlue : backgroundColor)
                    .shadow(
                        color: isFocused ? AppColors.neonCyan.opacity(0.8) : backgroundColor.opacity(0.3),
                        radius: isFocused ? 20 : 8,
                        x: 0,
                        y: isFocused ? 8 : 4
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                    .stroke(isFocused ? Color.white : Color.clear, lineWidth: 3)
            )
            .scaleEffect(isFocused ? 1.08 : (configuration.isPressed ? 0.96 : 1.0))
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

/// Secondary translucent button style for auxiliary actions.
public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isFocused) private var isFocused: Bool
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body)
            .fontWeight(.semibold)
            .foregroundColor(isFocused ? .white : AppColors.textSecondary)
            .padding(.vertical, 14)
            .padding(.horizontal, 28)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                    .fill(isFocused ? AppColors.cardBackgroundHover : AppColors.cardBackground.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                    .stroke(isFocused ? AppColors.neonCyan : AppColors.cardBorder, lineWidth: 2)
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

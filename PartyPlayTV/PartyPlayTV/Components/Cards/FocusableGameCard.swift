import SwiftUI

/// Reusable focusable container card with tvOS parallax focus lift, glowing borders, and rounded corners.
public struct FocusableGameCard<Content: View>: View {
    @FocusState private var isCardFocused: Bool
    private let content: Content
    private let cornerRadius: CGFloat
    private let action: () -> Void
    
    public init(
        cornerRadius: CGFloat = AppSpacing.cardCornerRadius,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.action = action
        self.content = content()
    }
    
    public var body: some View {
        Button(action: action) {
            content
                .padding(AppSpacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isCardFocused ? AppColors.cardBackgroundHover : AppColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            isCardFocused ? AppColors.neonCyan : AppColors.cardBorder.opacity(0.6),
                            lineWidth: isCardFocused ? 3.5 : 1.5
                        )
                )
                .shadow(
                    color: isCardFocused ? AppColors.neonCyan.opacity(0.4) : Color.black.opacity(0.3),
                    radius: isCardFocused ? 24 : 10,
                    x: 0,
                    y: isCardFocused ? 12 : 5
                )
        }
        .buttonStyle(.plain)
        .focused($isCardFocused)
        .scaleEffect(isCardFocused ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.22), value: isCardFocused)
    }
}

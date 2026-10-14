import SwiftUI

/// Reusable focusable container card with tvOS parallax focus lift, glowing borders, and rounded corners.
public struct FocusableGameCard<Content: View>: View {
    @Environment(\.isFocused) private var isEnvironmentFocused: Bool
    @FocusState private var isSelfFocused: Bool
    
    private var isFocused: Bool {
        isEnvironmentFocused || isSelfFocused
    }
    
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
                        .fill(isFocused ? AppColors.cardBackgroundHover : AppColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            isFocused ? AppColors.neonCyan : AppColors.cardBorder.opacity(0.6),
                            lineWidth: isFocused ? 3.5 : 1.5
                        )
                )
                .shadow(
                    color: isFocused ? AppColors.neonCyan.opacity(0.4) : Color.black.opacity(0.3),
                    radius: isFocused ? 20 : 10,
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

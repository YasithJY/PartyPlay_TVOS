import SwiftUI

/// Empty state view presented when no game history or participants are found.
public struct EmptyStateView: View {
    private let iconName: String
    private let title: String
    private let message: String
    
    public init(
        iconName: String = "tray.fill",
        title: String,
        message: String
    ) {
        self.iconName = iconName
        self.title = title
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: 18) {
            Image(systemName: iconName)
                .font(.system(size: 64))
                .foregroundColor(AppColors.textMuted)
            
            Text(title)
                .font(AppTypography.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Text(message)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 500)
        }
        .padding(AppSpacing.xxLarge)
    }
}

/// Loading view with tvOS styling.
public struct LoadingView: View {
    private let statusMessage: String
    
    public init(statusMessage: String = "Loading Game...") {
        self.statusMessage = statusMessage
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(2.0)
                .tint(AppColors.neonCyan)
            
            Text(statusMessage)
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

import SwiftUI

/// Section header displaying title, subtitle, and an optional icon badge.
public struct SectionHeader: View {
    private let title: String
    private let subtitle: String?
    private let iconName: String?
    
    public init(title: String, subtitle: String? = nil, iconName: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 12) {
                if let icon = iconName {
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppColors.neonCyan)
                }
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
            if let sub = subtitle {
                Text(sub)
                    .font(AppTypography.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

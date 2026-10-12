import SwiftUI

/// Standard spacing and layout metrics for tvOS screen dimensions (1920x1080 / 3840x2160).
public struct AppSpacing {
    public static let xxxSmall: CGFloat = 4
    public static let xxSmall: CGFloat = 8
    public static let xSmall: CGFloat = 12
    public static let small: CGFloat = 16
    public static let medium: CGFloat = 24
    public static let large: CGFloat = 32
    public static let xLarge: CGFloat = 48
    public static let xxLarge: CGFloat = 64
    public static let xxxLarge: CGFloat = 80
    
    // Television Screen Over-scan Safe Margins
    public static let tvSafeMarginHorizontal: CGFloat = 80
    public static let tvSafeMarginVertical: CGFloat = 60
    
    // Corner Radii
    public static let cardCornerRadius: CGFloat = 24
    public static let buttonCornerRadius: CGFloat = 20
    public static let badgeCornerRadius: CGFloat = 12
}

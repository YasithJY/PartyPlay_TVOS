import SwiftUI

/// Television typography calibrated for 10-foot viewing distances (Apple TV 4K & HD).
public struct AppTypography {
    public static let heroTitle = Font.system(size: 64, weight: .black, design: .rounded)
    public static let sectionTitle = Font.system(size: 44, weight: .bold, design: .rounded)
    public static let headline = Font.system(size: 36, weight: .bold, design: .rounded)
    public static let cardTitle = Font.system(size: 30, weight: .bold, design: .rounded)
    public static let questionPrompt = Font.system(size: 42, weight: .heavy, design: .rounded)
    public static let optionText = Font.system(size: 30, weight: .semibold, design: .rounded)
    public static let subheadline = Font.system(size: 26, weight: .medium, design: .default)
    public static let body = Font.system(size: 24, weight: .regular, design: .default)
    public static let caption = Font.system(size: 20, weight: .medium, design: .default)
    public static let scoreDigits = Font.system(size: 52, weight: .black, design: .monospaced)
    public static let countdownDigits = Font.system(size: 72, weight: .heavy, design: .monospaced)
}

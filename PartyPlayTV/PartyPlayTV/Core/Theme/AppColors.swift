import SwiftUI

/// Premium entertainment game-show color palette.
/// Rich dark charcoal canvas with electric purple, vivid cyan, amber gold, and neon accents.
public struct AppColors {
    // Backgrounds
    public static let backgroundDark = Color(red: 0.05, green: 0.06, blue: 0.10)
    public static let cardBackground = Color(red: 0.10, green: 0.12, blue: 0.18)
    public static let cardBackgroundHover = Color(red: 0.15, green: 0.18, blue: 0.26)
    public static let cardBorder = Color(red: 0.22, green: 0.26, blue: 0.38)
    
    // Primary & Accent Brand Colors
    public static let electricPurple = Color(red: 0.49, green: 0.30, blue: 1.00) // #7C4DFF
    public static let vividBlue = Color(red: 0.00, green: 0.55, blue: 1.00)      // #008CFF
    public static let neonCyan = Color(red: 0.00, green: 0.90, blue: 1.00)       // #00E5FF
    public static let neonPink = Color(red: 1.00, green: 0.25, blue: 0.51)       // #FF4081
    public static let accentGold = Color(red: 1.00, green: 0.73, blue: 0.10)     // #FFBA1A
    public static let vibrantOrange = Color(red: 1.00, green: 0.43, blue: 0.00)  // #FF6D00
    
    // Status & Feedback Colors
    public static let correctGreen = Color(red: 0.00, green: 0.85, blue: 0.45)   // #00D973
    public static let incorrectRed = Color(red: 1.00, green: 0.22, blue: 0.30)   // #FF384D
    public static let timerWarning = Color(red: 1.00, green: 0.65, blue: 0.00)   // #FFA600
    
    // Typography Colors
    public static let textPrimary = Color.white
    public static let textSecondary = Color(red: 0.70, green: 0.73, blue: 0.82)
    public static let textMuted = Color(red: 0.45, green: 0.48, blue: 0.58)
    
    // Gradients
    public static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.07, green: 0.05, blue: 0.14),
            Color(red: 0.04, green: 0.04, blue: 0.08),
            Color(red: 0.02, green: 0.03, blue: 0.06)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let brandGradient = LinearGradient(
        colors: [electricPurple, vividBlue],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public static let goldGradient = LinearGradient(
        colors: [Color(red: 1.00, green: 0.84, blue: 0.00), Color(red: 1.00, green: 0.55, blue: 0.00)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let correctGradient = LinearGradient(
        colors: [Color(red: 0.00, green: 0.90, blue: 0.50), Color(red: 0.00, green: 0.70, blue: 0.35)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let incorrectGradient = LinearGradient(
        colors: [Color(red: 1.00, green: 0.25, blue: 0.35), Color(red: 0.85, green: 0.10, blue: 0.20)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

public extension Color {
    init(hex: String) {
        let cleanHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleanHex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 124, 77, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

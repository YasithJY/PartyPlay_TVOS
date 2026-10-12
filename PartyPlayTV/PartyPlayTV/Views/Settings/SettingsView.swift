import SwiftUI

/// Settings view managing audio preferences, accessibility, match defaults, and persistence reset.
public struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @FocusState private var focusedField: String?
    
    private let onBack: () -> Void
    
    public init(onBack: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel())
        self.onBack = onBack
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                // Header
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Settings & Preferences")
                            .font(AppTypography.sectionTitle)
                            .foregroundColor(.white)
                        Text("Audio, game defaults, and system storage")
                            .font(AppTypography.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.top, AppSpacing.tvSafeMarginVertical)
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // Settings Form
                VStack(spacing: 24) {
                    // Audio & Feedback Row
                    SettingToggleRow(
                        title: "Game Show Sound Effects",
                        subtitle: "Play buzzer sound effects and countdown chime cues",
                        isOn: $viewModel.settings.soundEffectsEnabled
                    )
                    
                    // Accessibility Row
                    SettingToggleRow(
                        title: "Reduce Motion",
                        subtitle: "Minimizes large camera zooms and ambient orb glows",
                        isOn: $viewModel.settings.reducedMotionPreferred
                    )
                    
                    // High Contrast Row
                    SettingToggleRow(
                        title: "High Contrast Outlines",
                        subtitle: "Enhances focus borders for easier viewing from distant couches",
                        isOn: $viewModel.settings.highContrastEnabled
                    )
                    
                    // Clear History Action Row
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Clear Match History")
                                .font(AppTypography.headline)
                                .foregroundColor(.white)
                            Text("Removes all saved past match results and high scores from local storage")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.clearGameHistory()
                        }) {
                            Text("Clear Data")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.incorrectRed)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Capsule().fill(AppColors.incorrectRed.opacity(0.15)))
                                .overlay(Capsule().stroke(AppColors.incorrectRed.opacity(0.5), lineWidth: 1.5))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                            .fill(AppColors.cardBackground)
                    )
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // About Section & App Version
                VStack(alignment: .leading, spacing: 8) {
                    Text("ABOUT PARTYPLAY TV")
                        .font(AppTypography.caption)
                        .tracking(3)
                        .foregroundColor(AppColors.textMuted)
                    
                    Text("PartyPlay TV — Version 1.0.0 (Build 2026.1)")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("SE4041 Mobile Application Design and Development • SLIIT")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textMuted)
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                .padding(.bottom, AppSpacing.tvSafeMarginVertical)
            }
        }
        .ambientGameBackground()
        .onChange(of: viewModel.settings) { _ in
            viewModel.save()
        }
    }
}

private struct SettingToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: { isOn.toggle() }) {
                HStack(spacing: 8) {
                    Text(isOn ? "ON" : "OFF")
                        .font(AppTypography.cardTitle)
                        .foregroundColor(isOn ? AppColors.correctGreen : AppColors.textMuted)
                    
                    Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 28))
                        .foregroundColor(isOn ? AppColors.correctGreen : AppColors.textMuted)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule().fill(isOn ? AppColors.correctGreen.opacity(0.15) : AppColors.cardBackgroundHover)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1.5)
                )
        )
    }
}

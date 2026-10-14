import SwiftUI

/// Answer option card supporting Siri Remote focus, letter badges, and correct/incorrect feedback states.
public struct AnswerOptionCard: View {
    @Environment(\.isFocused) private var isEnvironmentFocused: Bool
    @FocusState private var isSelfFocused: Bool
    
    private var isFocused: Bool {
        isEnvironmentFocused || isSelfFocused
    }
    
    private let option: AnswerOption
    private let indexLetter: String
    private let isSelected: Bool
    private let isAnswerSubmitted: Bool
    private let isCorrectChoice: Bool
    private let action: () -> Void
    
    public init(
        option: AnswerOption,
        indexLetter: String,
        isSelected: Bool,
        isAnswerSubmitted: Bool,
        isCorrectChoice: Bool,
        action: @escaping () -> Void
    ) {
        self.option = option
        self.indexLetter = indexLetter
        self.isSelected = isSelected
        self.isAnswerSubmitted = isAnswerSubmitted
        self.isCorrectChoice = isCorrectChoice
        self.action = action
    }
    
    private var cardBackgroundFill: Color {
        if isAnswerSubmitted {
            if isCorrectChoice {
                return AppColors.correctGreen.opacity(0.35)
            } else if isSelected {
                return AppColors.incorrectRed.opacity(0.35)
            } else {
                return AppColors.cardBackground.opacity(0.4)
            }
        }
        return isFocused ? AppColors.cardBackgroundHover : AppColors.cardBackground
    }
    
    private var borderStrokeColor: Color {
        if isAnswerSubmitted {
            if isCorrectChoice {
                return AppColors.correctGreen
            } else if isSelected {
                return AppColors.incorrectRed
            } else {
                return AppColors.cardBorder.opacity(0.3)
            }
        }
        return isFocused ? AppColors.neonCyan : AppColors.cardBorder
    }
    
    private var badgeBackgroundColor: Color {
        if isFocused {
            return AppColors.neonCyan
        }
        if isAnswerSubmitted {
            if isCorrectChoice {
                return AppColors.correctGreen
            } else if isSelected {
                return AppColors.incorrectRed
            }
        }
        return AppColors.electricPurple
    }
    
    public var body: some View {
        Button(action: {
            if !isAnswerSubmitted {
                action()
            }
        }) {
            HStack(spacing: 20) {
                // Index letter badge (A, B, C, D)
                Text(indexLetter)
                    .font(AppTypography.cardTitle)
                    .foregroundColor(isFocused ? .black : .white)
                    .frame(width: 52, height: 52)
                    .background(
                        Circle().fill(badgeBackgroundColor)
                    )
                
                Text(option.text)
                    .font(AppTypography.optionText)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.leading)
                
                Spacer(minLength: 8)
                
                // Result Feedback icon
                if isAnswerSubmitted {
                    if isCorrectChoice {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(AppColors.correctGreen)
                    } else if isSelected {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(AppColors.incorrectRed)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity, minHeight: 90)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                    .fill(cardBackgroundFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.buttonCornerRadius)
                    .stroke(borderStrokeColor, lineWidth: (isFocused || isAnswerSubmitted) ? 3.5 : 1.5)
            )
            .shadow(
                color: isFocused ? AppColors.neonCyan.opacity(0.35) : Color.black.opacity(0.2),
                radius: isFocused ? 16 : 4,
                x: 0,
                y: isFocused ? 6 : 2
            )
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
        .focused($isSelfFocused)
        .disabled(isAnswerSubmitted)
        .scaleEffect(isFocused ? 1.025 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

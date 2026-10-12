import SwiftUI

/// Animated circular countdown timer with color shifting and pulsing warning state.
public struct CountdownView: View {
    private let timeRemaining: TimeInterval
    private let totalTime: TimeInterval
    
    public init(timeRemaining: TimeInterval, totalTime: TimeInterval) {
        self.timeRemaining = timeRemaining
        self.totalTime = max(totalTime, 1.0)
    }
    
    private var progress: Double {
        max(0.0, min(1.0, timeRemaining / totalTime))
    }
    
    private var timerColor: Color {
        if timeRemaining <= 3 {
            return AppColors.incorrectRed
        } else if timeRemaining <= 7 {
            return AppColors.timerWarning
        } else {
            return AppColors.neonCyan
        }
    }
    
    public var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(AppColors.cardBorder, lineWidth: 10)
                .frame(width: 140, height: 140)
            
            // Progress ring
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(
                    timerColor,
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 140, height: 140)
                .animation(.linear(duration: 0.5), value: progress)
            
            // Numerical seconds display
            VStack(spacing: 0) {
                Text("\(Int(ceil(timeRemaining)))")
                    .font(AppTypography.countdownDigits)
                    .foregroundColor(timerColor)
                    .contentTransition(.numericText())
                
                Text("SEC")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.textMuted)
            }
        }
        .scaleEffect(timeRemaining <= 3 ? 1.08 : 1.0)
        .animation(.easeInOut(duration: 0.3).repeatCount(timeRemaining <= 3 ? 3 : 1), value: timeRemaining)
    }
}

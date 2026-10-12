import SwiftUI

/// Screen displaying instructions for connecting smartphones as controllers.
public struct JoinGameView: View {
    @EnvironmentObject private var container: AppContainer
    private let onBack: () -> Void
    
    public init(onBack: @escaping () -> Void) {
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
                        Text("Connect Phone Controller")
                            .font(AppTypography.sectionTitle)
                            .foregroundColor(.white)
                        Text("Transform smartphones into interactive buzzers")
                            .font(AppTypography.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.top, AppSpacing.tvSafeMarginVertical)
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // Instructions Layout
                HStack(alignment: .top, spacing: 48) {
                    // Left QR Code Card
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "Step 1: Scan QR Code")
                        
                        if let qr = container.qrCodeService.generateQRCode(from: "\(container.settings.companionHostURL)?room=\(container.gameRoomService.roomCode)") {
                            qr
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 260, height: 260)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: AppColors.neonCyan.opacity(0.3), radius: 14)
                        }
                        
                        Text("Or open browser: partyplay.tv/join")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.neonCyan)
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                            .fill(AppColors.cardBackground)
                    )
                    
                    // Right Instruction Cards
                    VStack(alignment: .leading, spacing: 24) {
                        SectionHeader(title: "How It Works")
                        
                        InstructionRow(
                            stepNumber: "1",
                            title: "Open Camera or Browser",
                            description: "Scan the QR code on the TV or visit the web address on any iOS or Android phone."
                        )
                        
                        InstructionRow(
                            stepNumber: "2",
                            title: "Enter Room Code & Name",
                            description: "Type the 6-letter room code displayed on the Apple TV and choose your player nickname."
                        )
                        
                        InstructionRow(
                            stepNumber: "3",
                            title: "Buzz In and Win!",
                            description: "When questions appear on the big screen, tap your answer choice instantly on your mobile phone."
                        )
                        
                        // Offline notice
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(AppColors.accentGold)
                            Text("Note: In offline demo mode, you can play directly using the Apple TV Siri Remote or enable simulated bots in the Lobby.")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textMuted)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                .padding(.bottom, AppSpacing.tvSafeMarginVertical)
            }
        }
        .ambientGameBackground()
    }
}

private struct InstructionRow: View {
    let stepNumber: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Text(stepNumber)
                .font(AppTypography.cardTitle)
                .foregroundColor(.black)
                .frame(width: 48, height: 48)
                .background(Circle().fill(AppColors.neonCyan))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTypography.cardTitle)
                    .foregroundColor(.white)
                Text(description)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

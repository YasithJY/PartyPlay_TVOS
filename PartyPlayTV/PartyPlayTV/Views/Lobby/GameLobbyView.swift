import SwiftUI

/// Television Lobby screen displaying the room code, QR code, participant avatars, and simulated demo players.
public struct GameLobbyView: View {
    @StateObject private var viewModel: GameLobbyViewModel
    @FocusState private var focusedField: String?
    
    private let onStartGame: ([Player]) -> Void
    private let onBack: () -> Void
    
    public init(
        configuration: GameConfiguration,
        roomService: LocalDemoRoomService,
        qrCodeService: QRCodeService = .shared,
        onStartGame: @escaping ([Player]) -> Void,
        onBack: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: GameLobbyViewModel(
            configuration: configuration,
            roomService: roomService,
            qrCodeService: qrCodeService
        ))
        self.onStartGame = onStartGame
        self.onBack = onBack
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                // Header with Room Code Banner
                HStack(alignment: .center) {
                    Button(action: onBack) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Setup")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    Spacer()
                    
                    // Prominent Room Code Display
                    HStack(spacing: 16) {
                        Text("ROOM CODE:")
                            .font(AppTypography.caption)
                            .tracking(2)
                            .foregroundColor(AppColors.textMuted)
                        
                        Text(viewModel.roomCode)
                            .font(AppTypography.headline)
                            .tracking(6)
                            .foregroundColor(AppColors.neonCyan)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(AppColors.cardBackground)
                                    .overlay(Capsule().stroke(AppColors.neonCyan, lineWidth: 2))
                            )
                    }
                }
                .padding(.top, AppSpacing.tvSafeMarginVertical)
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                
                // Lobby Content Grid: Left QR & Join Info, Right Player Roster
                HStack(alignment: .top, spacing: 48) {
                    // Left Column: Companion Join & QR Code Card
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(
                            title: "Join with Phone",
                            subtitle: "Scan with camera or visit partyplay.tv/join",
                            iconName: "iphone.radiowaves.left.and.right"
                        )
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                                        .stroke(AppColors.cardBorder, lineWidth: 1.5)
                                )
                            
                            VStack(spacing: 18) {
                                if let qr = viewModel.qrCodeImage {
                                    qr
                                        .interpolation(.none)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 220, height: 220)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: AppColors.neonCyan.opacity(0.3), radius: 14)
                                } else {
                                    ProgressView()
                                        .frame(width: 220, height: 220)
                                }
                                
                                Text("Offline Demo Mode: Simulated bots can be added instantly without internet")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.textMuted)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                            }
                            .padding(24)
                        }
                        .frame(width: 440)
                    }
                    
                    // Right Column: Active Players Grid & Controls
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            SectionHeader(
                                title: "Party Roster (\(viewModel.players.count) Players)",
                                subtitle: "Living room host & companion participants",
                                iconName: "person.3.fill"
                            )
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.addBot()
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Bot")
                                }
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                        
                        // Player Avatars Grid
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 24)], spacing: 24) {
                                ForEach(viewModel.players) { player in
                                    PlayerAvatarView(player: player, size: 84)
                                }
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                                    .fill(AppColors.cardBackground.opacity(0.6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppSpacing.cardCornerRadius)
                                            .stroke(AppColors.cardBorder, lineWidth: 1.5)
                                    )
                            )
                        }
                        .frame(height: 300)
                        
                        // Start Match Action
                        HStack {
                            Spacer()
                            Button(action: {
                                onStartGame(viewModel.players)
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 32))
                                    Text("Start Game Show")
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle(backgroundColor: AppColors.correctGreen))
                            .focused($focusedField, equals: "startGame")
                            .disabled(!viewModel.isReadyToStart)
                            Spacer()
                        }
                        .padding(.top, 12)
                    }
                }
                .padding(.horizontal, AppSpacing.tvSafeMarginHorizontal)
                .padding(.bottom, AppSpacing.tvSafeMarginVertical)
            }
        }
        .ambientGameBackground()
        .onAppear {
            if focusedField == nil {
                focusedField = "startGame"
            }
        }
    }
}

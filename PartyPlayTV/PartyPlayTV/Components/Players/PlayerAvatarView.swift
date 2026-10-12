import SwiftUI

/// Player avatar view with status badges, host indicators, and simulated tags.
public struct PlayerAvatarView: View {
    private let player: Player
    private let size: CGFloat
    
    public init(player: Player, size: CGFloat = 80) {
        self.player = player
        self.size = size
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(hex: player.avatarColorHex))
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: player.avatarSymbol)
                            .font(.system(size: size * 0.45, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .shadow(color: Color(hex: player.avatarColorHex).opacity(0.5), radius: 10, x: 0, y: 4)
                
                if player.isHost {
                    Image(systemName: "crown.fill")
                        .font(.system(size: size * 0.28))
                        .foregroundColor(AppColors.accentGold)
                        .background(Circle().fill(AppColors.cardBackground).frame(width: size * 0.36, height: size * 0.36))
                        .offset(x: 4, y: 4)
                } else if player.isReady {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: size * 0.28))
                        .foregroundColor(AppColors.correctGreen)
                        .background(Circle().fill(AppColors.cardBackground).frame(width: size * 0.34, height: size * 0.34))
                        .offset(x: 4, y: 4)
                }
            }
            
            Text(player.name)
                .font(AppTypography.caption)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(1)
            
            if player.isSimulated {
                Text("BOT")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(AppColors.neonCyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(AppColors.neonCyan.opacity(0.18)))
            }
        }
        .frame(width: size + 40)
    }
}

import SwiftUI

/// Custom ViewModifier providing a dark game-show ambient background.
public struct AmbientGameBackgroundModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            // Subtle glowing ambient light orbs
            GeometryReader { proxy in
                Circle()
                    .fill(AppColors.electricPurple.opacity(0.12))
                    .frame(width: 600, height: 600)
                    .blur(radius: 120)
                    .position(x: proxy.size.width * 0.15, y: proxy.size.height * 0.2)
                
                Circle()
                    .fill(AppColors.vividBlue.opacity(0.10))
                    .frame(width: 500, height: 500)
                    .blur(radius: 100)
                    .position(x: proxy.size.width * 0.85, y: proxy.size.height * 0.75)
            }
            .ignoresSafeArea()
            
            content
        }
    }
}

public extension View {
    func ambientGameBackground() -> some View {
        modifier(AmbientGameBackgroundModifier())
    }
}

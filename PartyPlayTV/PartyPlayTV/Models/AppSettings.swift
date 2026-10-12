import Foundation

/// User preferences persisted locally via UserDefaults.
public struct AppSettings: Codable, Equatable {
    public var soundEffectsEnabled: Bool
    public var reducedMotionPreferred: Bool
    public var defaultTimerSeconds: Int
    public var defaultQuestionCount: Int
    public var highContrastEnabled: Bool
    public var companionHostURL: String
    
    public init(
        soundEffectsEnabled: Bool = true,
        reducedMotionPreferred: Bool = false,
        defaultTimerSeconds: Int = 15,
        defaultQuestionCount: Int = 5,
        highContrastEnabled: Bool = false,
        companionHostURL: String = "https://partyplay.tv/join"
    ) {
        self.soundEffectsEnabled = soundEffectsEnabled
        self.reducedMotionPreferred = reducedMotionPreferred
        self.defaultTimerSeconds = defaultTimerSeconds
        self.defaultQuestionCount = defaultQuestionCount
        self.highContrastEnabled = highContrastEnabled
        self.companionHostURL = companionHostURL
    }
    
    public static var `default`: AppSettings {
        AppSettings()
    }
}

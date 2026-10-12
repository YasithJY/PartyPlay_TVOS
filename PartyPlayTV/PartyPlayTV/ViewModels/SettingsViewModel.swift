import SwiftUI

/// ViewModel for managing user settings, persistence, and reset states.
public final class SettingsViewModel: ObservableObject {
    @Published public var settings: AppSettings
    @Published public var isSavedSuccessfully: Bool = false
    
    private let appContainer: AppContainer
    
    public init(appContainer: AppContainer = .shared) {
        self.appContainer = appContainer
        self.settings = appContainer.settings
    }
    
    public func save() {
        appContainer.updateSettings(settings)
        isSavedSuccessfully = true
    }
    
    public func resetToDefaults() {
        self.settings = AppSettings.default
        appContainer.updateSettings(settings)
    }
    
    public func clearGameHistory() {
        appContainer.persistenceService.clearHistory()
    }
}

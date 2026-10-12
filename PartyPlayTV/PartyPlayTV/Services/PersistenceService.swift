import Foundation

/// Defines the persistence contract for saving settings, game history, and high scores.
public protocol PersistenceServiceProtocol {
    func loadSettings() -> AppSettings
    func saveSettings(_ settings: AppSettings)
    func loadGameHistory() -> [GameResult]
    func saveGameResult(_ result: GameResult)
    func clearHistory()
}

/// Robust local persistence implementation using UserDefaults and JSON files in the Application Support directory.
public final class PersistenceService: PersistenceServiceProtocol {
    public static let shared = PersistenceService()
    
    private let userDefaults: UserDefaults
    private let settingsKey = "partyplay_tv_app_settings"
    private let fileManager: FileManager
    
    private var historyFileURL: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDir = appSupport.appendingPathComponent("PartyPlayTV", isDirectory: true)
        
        // Ensure directory exists
        if !fileManager.fileExists(atPath: appDir.path) {
            try? fileManager.createDirectory(at: appDir, withIntermediateDirectories: true, attributes: nil)
        }
        return appDir.appendingPathComponent("game_history.json")
    }
    
    public init(userDefaults: UserDefaults = .standard, fileManager: FileManager = .default) {
        self.userDefaults = userDefaults
        self.fileManager = fileManager
    }
    
    // MARK: - App Settings
    
    public func loadSettings() -> AppSettings {
        guard let data = userDefaults.data(forKey: settingsKey) else {
            return AppSettings.default
        }
        do {
            return try JSONDecoder().decode(AppSettings.self, from: data)
        } catch {
            print("[PersistenceService] Failed to decode settings, using defaults: \(error)")
            return AppSettings.default
        }
    }
    
    public func saveSettings(_ settings: AppSettings) {
        do {
            let data = try JSONEncoder().encode(settings)
            userDefaults.set(data, forKey: settingsKey)
        } catch {
            print("[PersistenceService] Failed to encode settings: \(error)")
        }
    }
    
    // MARK: - Game History
    
    public func loadGameHistory() -> [GameResult] {
        guard fileManager.fileExists(atPath: historyFileURL.path) else {
            return []
        }
        do {
            let data = try Data(contentsOf: historyFileURL)
            let history = try JSONDecoder().decode([GameResult].self, from: data)
            return history.sorted { $0.date > $1.date } // Most recent first
        } catch {
            print("[PersistenceService] Failed to load history: \(error)")
            return []
        }
    }
    
    public func saveGameResult(_ result: GameResult) {
        var currentHistory = loadGameHistory()
        currentHistory.insert(result, at: 0) // Prepend new result
        
        // Keep last 30 games to preserve memory and disk space
        if currentHistory.count > 30 {
            currentHistory = Array(currentHistory.prefix(30))
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(currentHistory)
            try data.write(to: historyFileURL, options: [.atomicWrite])
        } catch {
            print("[PersistenceService] Failed to persist game result: \(error)")
        }
    }
    
    public func clearHistory() {
        try? fileManager.removeItem(at: historyFileURL)
    }
}

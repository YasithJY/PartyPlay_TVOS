import Foundation

/// Difficulty level controlling question complexity and base point weightings.
public enum DifficultyLevel: String, CaseIterable, Codable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case all = "All Difficulties"
    
    public var id: String { rawValue }
    
    public var basePoints: Int {
        switch self {
        case .easy:
            return 100
        case .medium:
            return 200
        case .hard:
            return 300
        case .all:
            return 150
        }
    }
    
    public var badgeLabel: String {
        switch self {
        case .easy:
            return "★ Easy"
        case .medium:
            return "★★ Medium"
        case .hard:
            return "★★★ Hard"
        case .all:
            return "★ Mixed"
        }
    }
}

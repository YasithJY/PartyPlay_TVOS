import Foundation

/// Core quiz category representing distinctive trivia themes.
public enum QuizCategory: String, CaseIterable, Codable, Identifiable {
    case generalKnowledge = "General Knowledge"
    case scienceTech = "Science & Technology"
    case moviesEntertainment = "Movies & Entertainment"
    case gaming = "Gaming"
    case sriLanka = "Sri Lanka Quiz"
    case kidsFamily = "Kids & Family"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .generalKnowledge:
            return "brain.head.profile"
        case .scienceTech:
            return "atom"
        case .moviesEntertainment:
            return "film"
        case .gaming:
            return "gamecontroller"
        case .sriLanka:
            return "flag"
        case .kidsFamily:
            return "figure.2.and.child.holdinghands"
        }
    }
    
    public var subtitle: String {
        switch self {
        case .generalKnowledge:
            return "Global facts, history, world wonders & trivia"
        case .scienceTech:
            return "Physics, modern computing, AI & astronomy"
        case .moviesEntertainment:
            return "Cinema classics, Oscars, music & pop culture"
        case .gaming:
            return "Retro arcade, esports, legendary game sagas"
        case .sriLanka:
            return "Island heritage, sports heroes, wildlife & landmarks"
        case .kidsFamily:
            return "Animated films, gentle science & fun animal facts"
        }
    }
    
    public var themeHexColor: String {
        switch self {
        case .generalKnowledge:
            return "#7C4DFF" // Electric Violet
        case .scienceTech:
            return "#00E5FF" // Neon Cyan
        case .moviesEntertainment:
            return "#FF4081" // Vivid Pink
        case .gaming:
            return "#00E676" // Neon Emerald
        case .sriLanka:
            return "#FFAB00" // Golden Amber
        case .kidsFamily:
            return "#FF6D00" // Vibrant Tangerine
        }
    }
}

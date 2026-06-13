import Foundation

enum CuisineID: String, Codable, CaseIterable, Identifiable {
    case sichuan
    case cantonese
    case jiangnan
    case northern
    case hunan
    case dimSum
    case noodles
    case snacks

    var id: String { rawValue }
}

enum HeatLevel: String, Codable, CaseIterable {
    case mild
    case medium
    case hot
    case veryHot
}

struct Dish: Identifiable, Codable, Hashable {
    let id: String
    let englishName: String
    let chineseName: String
    let pinyin: String
    let japaneseName: String
    let cuisineID: CuisineID
    let heatLevel: HeatLevel
    let flavorKeys: [String]
    let ingredients: [String]
    let orderingPhrase: String
    let cultureNote: String
    let bestWith: String
    let searchTokens: [String]
}

struct Cuisine: Identifiable, Codable, Hashable {
    let id: CuisineID
    let englishName: String
    let chineseName: String
    let japaneseName: String
    let shortDescription: String
    let orderingTip: String
    let representativeDishIDs: [String]
}

struct Phrase: Identifiable, Codable, Hashable {
    let id: String
    let english: String
    let chinese: String
    let pinyin: String
    let japanese: String
    let usage: String
}

struct CultureCard: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let body: String
    let relatedDishID: String?
}

struct AppContent: Codable {
    let dishes: [Dish]
    let cuisines: [Cuisine]
    let phrases: [Phrase]
    let cultureCards: [CultureCard]
}

enum SavedKind: String, Codable, CaseIterable, Identifiable {
    case wantToTry
    case liked
    case saved

    var id: String { rawValue }
}

struct UserState: Codable, Equatable {
    var savedDishIDs: Set<String> = []
    var wantToTryDishIDs: Set<String> = []
    var likedDishIDs: Set<String> = []
    var recentDishIDs: [String] = []
    var recentPhraseIDs: [String] = []
    var languageCode: AppLanguage?
    var hasCompletedWelcome = false

    static let empty = UserState()
}

enum AppLanguage: String, Codable, CaseIterable, Identifiable {
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case japanese = "ja"

    var id: String { rawValue }

    var localeIdentifier: String { rawValue }

    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .simplifiedChinese:
            return "简体中文"
        case .japanese:
            return "日本語"
        }
    }

    static func inferred() -> AppLanguage {
        let preferred = Locale.preferredLanguages.map { $0.lowercased() }
        if preferred.contains(where: { $0.hasPrefix("zh") }) {
            return .simplifiedChinese
        }
        if preferred.contains(where: { $0.hasPrefix("ja") }) {
            return .japanese
        }

        let region = Locale.current.region?.identifier.uppercased()
        if region == "CN" || region == "TW" || region == "HK" || region == "MO" {
            return .simplifiedChinese
        }
        if region == "JP" {
            return .japanese
        }
        return .english
    }
}

enum ScreenshotMode {
    case disabled
    case demoData

    static var current: ScreenshotMode {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("--screenshot-demo-data") ? .demoData : .disabled
        #else
        return .disabled
        #endif
    }
}


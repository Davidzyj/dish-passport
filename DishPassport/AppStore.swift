import Foundation
import SwiftUI

@MainActor
final class AppStore: ObservableObject {
    @Published private(set) var content: AppContent
    @Published private(set) var userState: UserState
    @Published var selectedTab: AppTab = .explore
    @Published var toastMessage: String?

    private let persistence: UserStatePersisting
    let screenshotMode: ScreenshotMode

    init(contentProvider: ContentProviding, persistence: UserStatePersisting, screenshotMode: ScreenshotMode) {
        self.persistence = persistence
        self.screenshotMode = screenshotMode
        self.content = contentProvider.loadContent(screenshotMode: screenshotMode)

        #if DEBUG
        if screenshotMode == .demoData {
            self.userState = UserState(
                savedDishIDs: ["mapo-tofu", "xiaolongbao", "char-siu"],
                wantToTryDishIDs: ["mapo-tofu", "hunan-fish-head", "har-gow"],
                likedDishIDs: ["xiaolongbao"],
                recentDishIDs: ["mapo-tofu", "dan-dan-noodles", "tea-eggs"],
                recentPhraseIDs: ["less-spicy"],
                languageCode: .english,
                hasCompletedWelcome: true
            )
            return
        }
        #endif

        self.userState = persistence.load()
    }

    var language: AppLanguage {
        userState.languageCode ?? AppLanguage.inferred()
    }

    var dishesByID: [String: Dish] {
        Dictionary(uniqueKeysWithValues: content.dishes.map { ($0.id, $0) })
    }

    var cuisinesByID: [CuisineID: Cuisine] {
        Dictionary(uniqueKeysWithValues: content.cuisines.map { ($0.id, $0) })
    }

    func localized(_ key: String) -> String {
        LocalizedText.text(key, language: language)
    }

    func dishTitle(_ dish: Dish) -> String {
        switch language {
        case .english:
            return dish.englishName
        case .simplifiedChinese:
            return dish.chineseName
        case .japanese:
            return dish.japaneseName
        }
    }

    func dishSubtitle(_ dish: Dish) -> String {
        switch language {
        case .english:
            return "\(dish.chineseName) · \(dish.pinyin)"
        case .simplifiedChinese:
            return "\(dish.englishName) · \(dish.pinyin)"
        case .japanese:
            return "\(dish.chineseName) · \(dish.englishName)"
        }
    }

    func cuisineTitle(_ cuisine: Cuisine) -> String {
        switch language {
        case .english:
            return cuisine.englishName
        case .simplifiedChinese:
            return cuisine.chineseName
        case .japanese:
            return cuisine.japaneseName
        }
    }

    func heatLabel(_ heatLevel: HeatLevel) -> String {
        switch heatLevel {
        case .mild:
            return localized("heat.mild")
        case .medium:
            return localized("heat.medium")
        case .hot:
            return localized("heat.hot")
        case .veryHot:
            return localized("heat.veryHot")
        }
    }

    func searchDishes(query: String) -> [Dish] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return Array(content.dishes.prefix(8))
        }
        let lower = trimmed.lowercased()
        return content.dishes.filter { dish in
            let searchable = ([dish.englishName, dish.chineseName, dish.pinyin, dish.japaneseName] + dish.searchTokens)
                .joined(separator: " ")
                .lowercased()
            return searchable.localizedCaseInsensitiveContains(lower)
        }
    }

    func isDishSaved(_ dishID: String) -> Bool {
        userState.savedDishIDs.contains(dishID)
    }

    func isWantToTry(_ dishID: String) -> Bool {
        userState.wantToTryDishIDs.contains(dishID)
    }

    func isLiked(_ dishID: String) -> Bool {
        userState.likedDishIDs.contains(dishID)
    }

    func toggleSaved(_ dish: Dish) {
        var state = userState
        if state.savedDishIDs.contains(dish.id) {
            state.savedDishIDs.remove(dish.id)
            toastMessage = localized("toast.removedSaved").replacingOccurrences(of: "%@", with: dishTitle(dish))
        } else {
            state.savedDishIDs.insert(dish.id)
            toastMessage = localized("toast.saved").replacingOccurrences(of: "%@", with: dishTitle(dish))
        }
        assignAndPersist(state)
    }

    func toggleWantToTry(_ dish: Dish) {
        var state = userState
        if state.wantToTryDishIDs.contains(dish.id) {
            state.wantToTryDishIDs.remove(dish.id)
            toastMessage = localized("toast.removedTry").replacingOccurrences(of: "%@", with: dishTitle(dish))
        } else {
            state.wantToTryDishIDs.insert(dish.id)
            state.savedDishIDs.insert(dish.id)
            toastMessage = localized("toast.tryList").replacingOccurrences(of: "%@", with: dishTitle(dish))
        }
        assignAndPersist(state)
    }

    func toggleLiked(_ dish: Dish) {
        var state = userState
        if state.likedDishIDs.contains(dish.id) {
            state.likedDishIDs.remove(dish.id)
            toastMessage = localized("toast.unliked").replacingOccurrences(of: "%@", with: dishTitle(dish))
        } else {
            state.likedDishIDs.insert(dish.id)
            state.savedDishIDs.insert(dish.id)
            toastMessage = localized("toast.liked").replacingOccurrences(of: "%@", with: dishTitle(dish))
        }
        assignAndPersist(state)
    }

    func addCuisineRepresentativesToTry(_ cuisine: Cuisine) {
        var state = userState
        var addedCount = 0
        for dishID in cuisine.representativeDishIDs {
            if !state.wantToTryDishIDs.contains(dishID) {
                addedCount += 1
            }
            state.wantToTryDishIDs.insert(dishID)
            state.savedDishIDs.insert(dishID)
        }
        assignAndPersist(state)
        let title = cuisineTitle(cuisine)
        if addedCount == 0 {
            toastMessage = localized("toast.cuisineAlreadyAdded").replacingOccurrences(of: "%@", with: title)
        } else {
            toastMessage = localized("toast.cuisineAdded").replacingOccurrences(of: "%@", with: title)
        }
    }

    func recordDishView(_ dish: Dish) {
        var state = userState
        state.recentDishIDs.removeAll { $0 == dish.id }
        state.recentDishIDs.insert(dish.id, at: 0)
        state.recentDishIDs = Array(state.recentDishIDs.prefix(10))
        assignAndPersist(state)
    }

    func recordPhraseView(_ phrase: Phrase) {
        var state = userState
        state.recentPhraseIDs.removeAll { $0 == phrase.id }
        state.recentPhraseIDs.insert(phrase.id, at: 0)
        state.recentPhraseIDs = Array(state.recentPhraseIDs.prefix(10))
        assignAndPersist(state)
    }

    func setLanguage(_ language: AppLanguage) {
        var state = userState
        state.languageCode = language
        assignAndPersist(state)
        toastMessage = localized("toast.languageChanged")
    }

    func useAutomaticLanguage() {
        var state = userState
        state.languageCode = nil
        assignAndPersist(state)
        toastMessage = localized("toast.languageChanged")
    }

    func resetSavedData() {
        var state = userState
        state.savedDishIDs = []
        state.wantToTryDishIDs = []
        state.likedDishIDs = []
        state.recentDishIDs = []
        state.recentPhraseIDs = []
        assignAndPersist(state)
        toastMessage = localized("toast.reset")
    }

    func dismissToast() {
        toastMessage = nil
    }

    private func assignAndPersist(_ state: UserState) {
        userState = state
        if screenshotMode == .disabled {
            persistence.save(state)
        }
    }
}

enum AppTab: Hashable {
    case explore
    case cuisines
    case saved
    case settings
}

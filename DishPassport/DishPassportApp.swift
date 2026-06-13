import SwiftUI

@main
struct DishPassportApp: App {
    @StateObject private var store = AppStore(
        contentProvider: AppContentProvider(),
        persistence: UserStatePersistence(),
        screenshotMode: ScreenshotMode.current
    )

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environment(\.locale, Locale(identifier: store.language.localeIdentifier))
                .preferredColorScheme(.light)
                .tint(AppTheme.chili)
        }
    }
}


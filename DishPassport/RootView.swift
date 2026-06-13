import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $store.selectedTab) {
                ExploreView()
                    .tabItem {
                        Label(store.localized("tab.explore"), systemImage: "magnifyingglass")
                    }
                    .tag(AppTab.explore)

                CuisinesView()
                    .tabItem {
                        Label(store.localized("tab.cuisines"), systemImage: "square.grid.2x2")
                    }
                    .tag(AppTab.cuisines)

                SavedView()
                    .tabItem {
                        Label(store.localized("tab.saved"), systemImage: "heart")
                    }
                    .tag(AppTab.saved)

                SettingsView()
                    .tabItem {
                        Label(store.localized("tab.settings"), systemImage: "line.3.horizontal")
                    }
                    .tag(AppTab.settings)
            }
            .background(AppTheme.background.ignoresSafeArea())

            if let message = store.toastMessage {
                ToastView(message: message)
                    .padding(.bottom, 70)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            withAnimation(.easeInOut) {
                                store.dismissToast()
                            }
                        }
                    }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: store.toastMessage)
    }
}

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(AppTheme.ink.opacity(0.94))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(.horizontal, 22)
    }
}


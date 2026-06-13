import SwiftUI

struct SavedView: View {
    @EnvironmentObject private var store: AppStore

    private var wantToTryDishes: [Dish] {
        dishes(for: store.userState.wantToTryDishIDs)
    }

    private var likedDishes: [Dish] {
        dishes(for: store.userState.likedDishIDs)
    }

    private var savedDishes: [Dish] {
        dishes(for: store.userState.savedDishIDs)
    }

    private var recentDishes: [Dish] {
        let byID = store.dishesByID
        return store.userState.recentDishIDs.compactMap { byID[$0] }
    }

    private var isEmpty: Bool {
        wantToTryDishes.isEmpty && likedDishes.isEmpty && savedDishes.isEmpty && recentDishes.isEmpty
    }

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(
                        eyebrow: store.localized("saved.subtitle"),
                        title: store.localized("saved.title")
                    )

                    if isEmpty {
                        EmptyStateView(title: store.localized("saved.empty"), systemImage: "bookmark")
                    } else {
                        SavedSection(title: store.localized("saved.wantToTry"), dishes: wantToTryDishes, emptyIcon: "sparkle")
                        SavedSection(title: store.localized("saved.liked"), dishes: likedDishes, emptyIcon: "heart")
                        SavedSection(title: store.localized("saved.allSaved"), dishes: savedDishes, emptyIcon: "bookmark")
                        SavedSection(title: store.localized("saved.recent"), dishes: recentDishes, emptyIcon: "clock")
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }

    private func dishes(for ids: Set<String>) -> [Dish] {
        store.content.dishes.filter { ids.contains($0.id) }
    }
}

struct SavedSection: View {
    @EnvironmentObject private var store: AppStore
    let title: String
    let dishes: [Dish]
    let emptyIcon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(title: title)

            if dishes.isEmpty {
                EmptyStateView(title: store.localized("saved.emptySection"), systemImage: emptyIcon)
            } else {
                VStack(spacing: 10) {
                    ForEach(dishes) { dish in
                        NavigationLink {
                            DishDetailView(dish: dish)
                        } label: {
                            DishRowView(dish: dish)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

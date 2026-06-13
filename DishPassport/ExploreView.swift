import SwiftUI
import UIKit

struct ExploreView: View {
    @EnvironmentObject private var store: AppStore
    @State private var query = ""
    @State private var copiedPhraseID: String?
    @FocusState private var searchFocused: Bool

    private var results: [Dish] {
        store.searchDishes(query: query)
    }

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ScreenHeader(
                        eyebrow: store.localized("home.greeting"),
                        title: store.localized("home.title"),
                        trailing: AnyView(
                            Button {
                                searchFocused = false
                                store.selectedTab = .settings
                            } label: {
                                Image(systemName: "gearshape")
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(AppTheme.ink)
                                    .frame(width: 42, height: 42)
                                    .background(AppTheme.paper)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        )
                    )

                    SearchField(
                        text: $query,
                        placeholder: store.localized("home.searchPlaceholder"),
                        isFocused: $searchFocused
                    )

                    if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        recommendation
                    }

                    resultsSection
                    phrasesSection
                    cultureSection
                }
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(store.localized("common.cancel")) {
                        searchFocused = false
                    }
                    .foregroundStyle(AppTheme.chiliDark)
                }
            }
        }
    }

    private var recommendation: some View {
        NavigationLink {
            DishDetailView(dish: store.content.dishes[0])
        } label: {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.localized("home.recommendation"))
                        .font(.caption.weight(.heavy))
                        .textCase(.uppercase)
                        .foregroundStyle(AppTheme.amberSoft)
                    Text(store.dishTitle(store.content.dishes[0]))
                        .font(.title.weight(.heavy))
                        .foregroundStyle(Color.white)
                    Text(store.content.dishes[0].cultureNote)
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 1.0, green: 0.89, blue: 0.76))
                        .lineLimit(3)
                }

                Spacer()
                DishGlyph(text: "麻", color: AppTheme.amber)
            }
            .padding(18)
            .background(
                LinearGradient(
                    colors: [AppTheme.chili, AppTheme.chiliDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(.horizontal, 20)
        }
        .buttonStyle(.plain)
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(query.isEmpty ? store.localized("home.popular") : String(format: store.localized("search.results"), results.count))
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(AppTheme.ink)
                Spacer()
            }
            .padding(.horizontal, 20)

            if results.isEmpty {
                EmptyStateView(title: store.localized("search.empty"), systemImage: "fork.knife.circle")
            } else {
                VStack(spacing: 10) {
                    ForEach(results) { dish in
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

    private var phrasesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(store.localized("home.phrases"))
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(AppTheme.ink)
                Spacer()
                NavigationLink(store.localized("common.seeAll")) {
                    PhrasesView()
                }
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(AppTheme.chiliDark)
            }
            .padding(.horizontal, 20)

            VStack(spacing: 10) {
                ForEach(store.content.phrases.prefix(2)) { phrase in
                    PhraseMiniCard(phrase: phrase, copiedPhraseID: $copiedPhraseID)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var cultureSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(store.localized("home.culture"))
                .font(.title3.weight(.heavy))
                .foregroundStyle(AppTheme.ink)
                .padding(.horizontal, 20)

            ForEach(store.content.cultureCards.prefix(2)) { card in
                VStack(alignment: .leading, spacing: 8) {
                    Text(card.title)
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                    Text(card.body)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .cardSurface()
                .padding(.horizontal, 20)
            }
        }
    }
}

struct PhraseMiniCard: View {
    @EnvironmentObject private var store: AppStore
    let phrase: Phrase
    @Binding var copiedPhraseID: String?

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text(phrase.english)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
                Text("\(phrase.chinese) · \(phrase.pinyin)")
                    .font(.caption)
                    .foregroundStyle(AppTheme.muted)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                UIPasteboard.general.string = phrase.chinese
                store.recordPhraseView(phrase)
                copiedPhraseID = phrase.id
            } label: {
                Label(
                    copiedPhraseID == phrase.id ? store.localized("common.copied") : store.localized("common.copy"),
                    systemImage: copiedPhraseID == phrase.id ? "checkmark" : "doc.on.doc"
                )
                .labelStyle(.iconOnly)
                .foregroundStyle(Color.white)
                .frame(width: 40, height: 40)
                .background(AppTheme.ink)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .accessibilityLabel(copiedPhraseID == phrase.id ? store.localized("common.copied") : store.localized("common.copy"))
        }
        .padding(14)
        .cardSurface()
    }
}

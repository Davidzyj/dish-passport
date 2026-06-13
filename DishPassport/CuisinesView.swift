import SwiftUI

struct CuisinesView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(
                        eyebrow: store.localized("cuisines.subtitle"),
                        title: store.localized("cuisines.title")
                    )

                    VStack(spacing: 10) {
                        ForEach(store.content.cuisines) { cuisine in
                            NavigationLink {
                                CuisineDetailView(cuisine: cuisine)
                            } label: {
                                CuisineRowView(cuisine: cuisine)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 24)
            }
        }
    }
}

struct CuisineRowView: View {
    @EnvironmentObject private var store: AppStore
    let cuisine: Cuisine

    private var savedCount: Int {
        cuisine.representativeDishIDs.filter { store.userState.wantToTryDishIDs.contains($0) }.count
    }

    var body: some View {
        HStack(spacing: 12) {
            DishGlyph(text: glyphText, color: glyphColor)

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(store.cuisineTitle(cuisine))
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(AppTheme.ink)
                        .lineLimit(1)
                    if savedCount > 0 {
                        Pill(text: "\(savedCount)", color: AppTheme.amberSoft)
                    }
                }
                Text(cuisine.shortDescription)
                    .font(.caption)
                    .foregroundStyle(AppTheme.muted)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.muted)
        }
        .padding(12)
        .cardSurface()
    }

    private var glyphText: String {
        switch cuisine.id {
        case .sichuan: return "川"
        case .cantonese: return "粤"
        case .jiangnan: return "江"
        case .northern: return "北"
        case .hunan: return "湘"
        case .dimSum: return "点"
        case .noodles: return "面"
        case .snacks: return "小"
        }
    }

    private var glyphColor: Color {
        switch cuisine.id {
        case .sichuan, .hunan:
            return AppTheme.chili
        case .cantonese, .dimSum:
            return AppTheme.jade
        case .jiangnan, .snacks:
            return AppTheme.amber
        case .northern, .noodles:
            return AppTheme.ink
        }
    }
}

struct CuisineDetailView: View {
    @EnvironmentObject private var store: AppStore
    let cuisine: Cuisine

    private var representativeDishes: [Dish] {
        let byID = store.dishesByID
        return cuisine.representativeDishIDs.compactMap { byID[$0] }
    }

    private var allInTryList: Bool {
        !cuisine.representativeDishIDs.isEmpty && cuisine.representativeDishIDs.allSatisfy { store.userState.wantToTryDishIDs.contains($0) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(store.cuisineTitle(cuisine))
                        .font(.largeTitle.weight(.heavy))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(cuisine.shortDescription)
                        .font(.body)
                        .foregroundStyle(AppTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)

                ActionButton(
                    title: allInTryList ? store.localized("cuisine.addedAll") : store.localized("cuisine.addAll"),
                    systemImage: allInTryList ? "checkmark.circle.fill" : "plus.circle",
                    background: allInTryList ? AppTheme.chiliDark : AppTheme.amber,
                    foreground: allInTryList ? .white : AppTheme.ink
                ) {
                    store.addCuisineRepresentativesToTry(cuisine)
                }
                .padding(.horizontal, 20)

                InfoBlock(title: store.localized("cuisine.tip"), bodyText: cuisine.orderingTip, icon: "lightbulb")
                    .padding(.horizontal, 20)

                SectionTitle(title: store.localized("cuisine.dishes"))

                VStack(spacing: 10) {
                    ForEach(representativeDishes) { dish in
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
            .padding(.bottom, 26)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

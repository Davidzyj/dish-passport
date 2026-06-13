import SwiftUI
import UIKit

struct DishDetailView: View {
    @EnvironmentObject private var store: AppStore
    let dish: Dish

    private var cuisine: Cuisine? {
        store.cuisinesByID[dish.cuisineID]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                actions
                facts
                orderBlock
                ingredientsBlock
                cultureBlock
            }
            .padding(.bottom, 28)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.recordDishView(dish)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 14) {
                DishGlyph(text: String(dish.chineseName.prefix(1)), color: glyphColor)
                    .frame(width: 64, height: 64)

                VStack(alignment: .leading, spacing: 6) {
                    Text(store.dishTitle(dish))
                        .font(.largeTitle.weight(.heavy))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(store.dishSubtitle(dish))
                        .font(.headline)
                        .foregroundStyle(AppTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            ChipFlow(values: dish.flavorKeys, color: AppTheme.amberSoft)
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }

    private var actions: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                ActionButton(
                    title: store.isDishSaved(dish.id) ? store.localized("common.saved") : store.localized("common.save"),
                    systemImage: store.isDishSaved(dish.id) ? "bookmark.fill" : "bookmark",
                    background: store.isDishSaved(dish.id) ? AppTheme.chili : AppTheme.ink
                ) {
                    store.toggleSaved(dish)
                }

                ActionButton(
                    title: store.isLiked(dish.id) ? store.localized("common.liked") : store.localized("common.like"),
                    systemImage: store.isLiked(dish.id) ? "heart.fill" : "heart",
                    background: store.isLiked(dish.id) ? AppTheme.chili : AppTheme.jade
                ) {
                    store.toggleLiked(dish)
                }
            }

            ActionButton(
                title: store.isWantToTry(dish.id) ? store.localized("common.removeTry") : store.localized("common.addTry"),
                systemImage: store.isWantToTry(dish.id) ? "checkmark.circle.fill" : "plus.circle",
                background: store.isWantToTry(dish.id) ? AppTheme.chiliDark : AppTheme.amber,
                foreground: store.isWantToTry(dish.id) ? .white : AppTheme.ink
            ) {
                store.toggleWantToTry(dish)
            }
        }
        .padding(.horizontal, 20)
    }

    private var facts: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            MetricTile(title: store.localized("detail.heat"), value: store.heatLabel(dish.heatLevel), color: AppTheme.amberSoft)
            MetricTile(title: store.localized("detail.region"), value: cuisine.map { store.cuisineTitle($0) } ?? dish.cuisineID.rawValue, color: AppTheme.jadeSoft)
            MetricTile(title: store.localized("detail.bestWith"), value: dish.bestWith, color: AppTheme.paperWarm)
            MetricTile(title: store.localized("detail.flavor"), value: dish.flavorKeys.joined(separator: ", "), color: AppTheme.paperWarm)
        }
        .padding(.horizontal, 20)
    }

    private var orderBlock: some View {
        InfoBlock(
            title: store.localized("detail.order"),
            bodyText: dish.orderingPhrase,
            icon: "quote.bubble"
        )
        .padding(.horizontal, 20)
    }

    private var ingredientsBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(store.localized("detail.ingredients"))
                .font(.headline.weight(.heavy))
                .foregroundStyle(AppTheme.ink)
            ChipFlow(values: dish.ingredients, color: AppTheme.jadeSoft)
        }
        .padding(14)
        .cardSurface()
        .padding(.horizontal, 20)
    }

    private var cultureBlock: some View {
        InfoBlock(
            title: store.localized("detail.culture"),
            bodyText: dish.cultureNote,
            icon: "sparkles"
        )
        .padding(.horizontal, 20)
    }

    private var glyphColor: Color {
        switch dish.cuisineID {
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

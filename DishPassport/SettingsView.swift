import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showingResetConfirmation = false

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(
                        eyebrow: store.localized("settings.subtitle"),
                        title: store.localized("settings.title")
                    )

                    privacyNote
                    languageSection
                    linksSection
                    dataSection
                    versionSection
                }
                .padding(.bottom, 24)
            }
        }
        .alert(store.localized("settings.resetTitle"), isPresented: $showingResetConfirmation) {
            Button(store.localized("common.cancel"), role: .cancel) {}
            Button(store.localized("common.reset"), role: .destructive) {
                store.resetSavedData()
            }
        } message: {
            Text(store.localized("settings.resetBody"))
        }
    }

    private var privacyNote: some View {
        InfoBlock(
            title: store.localized("settings.privacyNoteTitle"),
            bodyText: store.localized("settings.privacyNoteBody"),
            icon: "lock.shield"
        )
        .padding(.horizontal, 20)
    }

    private var languageSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(title: store.localized("settings.language"), subtitle: store.localized("language.system"))
            VStack(spacing: 8) {
                LanguageRow(
                    title: store.localized("settings.automaticLanguage"),
                    subtitle: AppLanguage.inferred().displayName,
                    selected: store.userState.languageCode == nil
                ) {
                    store.useAutomaticLanguage()
                }

                ForEach(AppLanguage.allCases) { language in
                    LanguageRow(
                        title: language.displayName,
                        subtitle: language.rawValue,
                        selected: store.userState.languageCode == language
                    ) {
                        store.setLanguage(language)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var linksSection: some View {
        VStack(spacing: 10) {
            SettingsLinkRow(
                title: store.localized("settings.privacy"),
                systemImage: "hand.raised",
                urlString: store.localized("link.privacy")
            )
            SettingsLinkRow(
                title: store.localized("settings.support"),
                systemImage: "envelope",
                urlString: store.localized("link.support")
            )
        }
        .padding(.horizontal, 20)
    }

    private var dataSection: some View {
        VStack(spacing: 10) {
            Button {
                showingResetConfirmation = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppTheme.chili)
                        .frame(width: 34, height: 34)
                        .background(AppTheme.amberSoft)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    Text(store.localized("settings.reset"))
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(AppTheme.ink)
                    Spacer()
                }
                .padding(14)
                .cardSurface()
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
    }

    private var versionSection: some View {
        HStack {
            Image(systemName: "info.circle")
                .font(.headline.weight(.bold))
                .foregroundStyle(AppTheme.jade)
                .frame(width: 34, height: 34)
                .background(AppTheme.jadeSoft)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            Text(store.localized("settings.version"))
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(AppTheme.muted)
            Spacer()
            Text("1.0.0")
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(AppTheme.ink)
        }
        .padding(14)
        .cardSurface()
        .padding(.horizontal, 20)
    }
}

struct LanguageRow: View {
    let title: String
    let subtitle: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(selected ? AppTheme.chili : AppTheme.muted)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(AppTheme.ink)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(AppTheme.muted)
                }

                Spacer()
            }
            .padding(12)
            .cardSurface()
        }
        .buttonStyle(.plain)
    }
}

struct SettingsLinkRow: View {
    let title: String
    let systemImage: String
    let urlString: String

    var body: some View {
        Link(destination: URL(string: urlString)!) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(AppTheme.jade)
                    .frame(width: 34, height: 34)
                    .background(AppTheme.jadeSoft)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                Text(title)
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(AppTheme.ink)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.subheadline.weight(.heavy))
                    .foregroundStyle(AppTheme.muted)
            }
            .padding(14)
            .cardSurface()
        }
    }
}

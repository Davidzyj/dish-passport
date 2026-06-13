import SwiftUI
import UIKit

struct PhrasesView: View {
    @EnvironmentObject private var store: AppStore

    private var recentPhrases: [Phrase] {
        let byID = Dictionary(uniqueKeysWithValues: store.content.phrases.map { ($0.id, $0) })
        return store.userState.recentPhraseIDs.compactMap { byID[$0] }
    }

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenHeader(
                        eyebrow: store.localized("phrases.subtitle"),
                        title: store.localized("phrases.title")
                    )

                    if !recentPhrases.isEmpty {
                        PhraseListSection(title: store.localized("phrases.recent"), phrases: recentPhrases)
                    }

                    PhraseListSection(title: store.localized("phrases.title"), phrases: store.content.phrases)
                }
                .padding(.bottom, 24)
            }
        }
    }
}

struct PhraseListSection: View {
    @EnvironmentObject private var store: AppStore
    let title: String
    let phrases: [Phrase]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(title: title)
            VStack(spacing: 10) {
                ForEach(phrases) { phrase in
                    NavigationLink {
                        PhraseDetailView(phrase: phrase)
                    } label: {
                        PhraseRowView(phrase: phrase)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct PhraseRowView: View {
    @EnvironmentObject private var store: AppStore
    let phrase: Phrase

    var body: some View {
        HStack(spacing: 12) {
            DishGlyph(text: String(phrase.chinese.prefix(1)), color: AppTheme.jade)
            VStack(alignment: .leading, spacing: 5) {
                Text(primaryLine)
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(1)
                Text("\(phrase.chinese) · \(phrase.pinyin)")
                    .font(.caption)
                    .foregroundStyle(AppTheme.muted)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            Image(systemName: store.userState.recentPhraseIDs.contains(phrase.id) ? "checkmark.circle.fill" : "doc.on.doc")
                .font(.title3)
                .foregroundStyle(store.userState.recentPhraseIDs.contains(phrase.id) ? AppTheme.chili : AppTheme.jade)
        }
        .padding(12)
        .cardSurface()
    }

    private var primaryLine: String {
        switch store.language {
        case .english:
            return phrase.english
        case .simplifiedChinese:
            return phrase.chinese
        case .japanese:
            return phrase.japanese
        }
    }
}

struct PhraseDetailView: View {
    @EnvironmentObject private var store: AppStore
    let phrase: Phrase
    @State private var copied = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(displayTitle)
                        .font(.largeTitle.weight(.heavy))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(phrase.chinese) · \(phrase.pinyin)")
                        .font(.headline)
                        .foregroundStyle(AppTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)

                VStack(alignment: .leading, spacing: 10) {
                    phraseLine(label: "English", value: phrase.english)
                    phraseLine(label: "中文", value: phrase.chinese)
                    phraseLine(label: "Pinyin", value: phrase.pinyin)
                    phraseLine(label: "日本語", value: phrase.japanese)
                }
                .padding(14)
                .cardSurface()
                .padding(.horizontal, 20)

                ActionButton(
                    title: copied ? store.localized("common.copied") : store.localized("phrases.copyChinese"),
                    systemImage: copied ? "checkmark" : "doc.on.doc",
                    background: copied ? AppTheme.chili : AppTheme.ink
                ) {
                    UIPasteboard.general.string = phrase.chinese
                    store.recordPhraseView(phrase)
                    copied = true
                }
                .padding(.horizontal, 20)

                InfoBlock(title: store.localized("phrases.usage"), bodyText: phrase.usage, icon: "fork.knife")
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 26)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.recordPhraseView(phrase)
        }
    }

    private var displayTitle: String {
        switch store.language {
        case .english:
            return phrase.english
        case .simplifiedChinese:
            return phrase.chinese
        case .japanese:
            return phrase.japanese
        }
    }

    private func phraseLine(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption.weight(.heavy))
                .textCase(.uppercase)
                .foregroundStyle(AppTheme.muted)
            Text(value)
                .font(.body.weight(.semibold))
                .foregroundStyle(AppTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

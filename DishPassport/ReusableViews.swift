import SwiftUI

struct AppScreen<Content: View>: View {
    let content: () -> Content

    var body: some View {
        NavigationStack {
            content()
                .background(AppTheme.background.ignoresSafeArea())
                .toolbarBackground(AppTheme.paper, for: .navigationBar)
                .toolbarColorScheme(.light, for: .navigationBar)
        }
    }
}

struct ScreenHeader: View {
    let eyebrow: String
    let title: String
    var trailing: AnyView?

    init(eyebrow: String, title: String, trailing: AnyView? = nil) {
        self.eyebrow = eyebrow
        self.title = title
        self.trailing = trailing
    }

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text(eyebrow)
                    .font(.caption.weight(.heavy))
                    .textCase(.uppercase)
                    .foregroundStyle(AppTheme.jade)
                Text(title)
                    .font(.largeTitle.weight(.heavy))
                    .foregroundStyle(AppTheme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
            trailing
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }
}

struct SearchField: View {
    @Binding var text: String
    let placeholder: String
    let isFocused: FocusState<Bool>.Binding

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.headline)
                .foregroundStyle(AppTheme.chili)
            TextField(text: $text, prompt: Text(placeholder).foregroundStyle(AppTheme.muted)) {
                EmptyView()
            }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(AppTheme.ink)
                .submitLabel(.done)
                .focused(isFocused)
                .onSubmit {
                    isFocused.wrappedValue = false
                }
        }
        .padding(.horizontal, 14)
        .frame(height: 50)
        .background(AppTheme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppTheme.line, lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}

struct DishRowView: View {
    @EnvironmentObject private var store: AppStore
    let dish: Dish
    var showsSavedState = true

    var body: some View {
        HStack(spacing: 12) {
            DishGlyph(text: String(dish.chineseName.prefix(1)), color: glyphColor)

            VStack(alignment: .leading, spacing: 4) {
                Text(store.dishTitle(dish))
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(1)
                Text(store.dishSubtitle(dish))
                    .font(.caption)
                    .foregroundStyle(AppTheme.muted)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            if showsSavedState {
                if store.isDishSaved(dish.id) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppTheme.chili)
                        .accessibilityLabel(store.localized("common.saved"))
                } else {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundStyle(AppTheme.jade)
                        .accessibilityLabel(store.localized("common.save"))
                }
            }
        }
        .padding(12)
        .cardSurface()
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

struct DishGlyph: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.title2.weight(.heavy))
            .foregroundStyle(Color.white)
            .frame(width: 50, height: 50)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct Pill: View {
    let text: String
    var color: Color = AppTheme.amberSoft

    var body: some View {
        Text(text)
            .font(.caption.weight(.heavy))
            .foregroundStyle(AppTheme.ink)
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct EmptyStateView: View {
    let title: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(AppTheme.jade)
            Text(title)
                .font(.body.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .cardSurface()
        .padding(.horizontal, 20)
    }
}

struct SectionTitle: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title3.weight(.heavy))
                .foregroundStyle(AppTheme.ink)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

struct MetricTile: View {
    let title: String
    let value: String
    var color: Color = AppTheme.jadeSoft

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.heavy))
                .textCase(.uppercase)
                .foregroundStyle(AppTheme.muted)
            Text(value)
                .font(.headline.weight(.heavy))
                .foregroundStyle(AppTheme.ink)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct ActionButton: View {
    let title: String
    let systemImage: String
    var background: Color = AppTheme.ink
    var foreground: Color = .white
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(foreground)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct InfoBlock: View {
    let title: String
    let bodyText: String
    var icon: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppTheme.chili)
                }
                Text(title)
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(AppTheme.ink)
            }
            Text(bodyText)
                .font(.body)
                .foregroundStyle(AppTheme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .cardSurface()
    }
}

struct ChipFlow: View {
    let values: [String]
    var color: Color = AppTheme.amberSoft

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(values, id: \.self) { value in
                Pill(text: value, color: color)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

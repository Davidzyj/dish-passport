import SwiftUI

enum AppTheme {
    static let background = Color(red: 0.969, green: 0.945, blue: 0.902)
    static let paper = Color(red: 1.0, green: 0.992, blue: 0.973)
    static let paperWarm = Color(red: 0.984, green: 0.961, blue: 0.918)
    static let ink = Color(red: 0.122, green: 0.149, blue: 0.137)
    static let muted = Color(red: 0.424, green: 0.384, blue: 0.345)
    static let chili = Color(red: 0.718, green: 0.192, blue: 0.173)
    static let chiliDark = Color(red: 0.561, green: 0.137, blue: 0.122)
    static let jade = Color(red: 0.184, green: 0.435, blue: 0.384)
    static let amber = Color(red: 0.847, green: 0.537, blue: 0.173)
    static let line = Color(red: 0.89, green: 0.843, blue: 0.773)
    static let jadeSoft = Color(red: 0.863, green: 0.922, blue: 0.890)
    static let amberSoft = Color(red: 0.957, green: 0.875, blue: 0.741)
}

extension View {
    func cardSurface() -> some View {
        self
            .background(AppTheme.paper)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppTheme.line, lineWidth: 1)
            )
    }

    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(AppTheme.ink)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}


import SwiftUI

struct SectionTextViewModifier: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .foregroundColor(theme.textColorLight)
            .font(.callout)
    }
}

extension View {
    func section() -> some View {
        modifier(SectionTextViewModifier())
    }
}

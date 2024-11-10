import Foundation
import SwiftUI
import Assets

package struct BuildioTextField<Trailing: View>: View {
    @Environment(\.theme) private var theme
    @Binding var text: String
    let placeholder: String
    let canClear: Bool
    let canPaste: Bool
    let trailing: () -> Trailing

    @FocusState private var isFocused: Bool

    package init(
        text: Binding<String>,
        placeholder: String,
        canClear: Bool = false,
        canPaste: Bool = false,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self._text = text
        self.placeholder = placeholder
        self.canClear = canClear
        self.canPaste = canPaste
        self.trailing = trailing
    }

    package var body: some View {
        HStack(alignment: .center, spacing: 2) {
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(theme.textColorLight.color))
                .font(.callout)
                .foregroundColor(theme.textColor.color)
                .focused($isFocused)
            if canClear, !text.isEmpty {
                Image(.delete_left)
                    .foregroundColor(theme.accentColor.color)
                    .button {
                        self.text = ""
                    }
                    .frame(height: 16)
            }
            if canPaste, text.isEmpty {
                Image(.doc_on_clipboard)
                    .foregroundColor(theme.accentColor.color)
                    .button {
                        #if os(iOS)
                        if let text = UIPasteboard.general.string {
                            self.text = text
                        }
                        #elseif os(macOS)
                        if let text = NSPasteboard.general.string(forType: .string) {
                            self.text = text
                        }
                        #endif
                    }
                    .frame(height: 16)
            }
            trailing()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(theme.background.color)
        .rounded(borderColor: isFocused ? theme.accentColor.color : theme.borderColor.color)
        .textFieldStyle(.plain)
        #if os(iOS)
            .textInputAutocapitalization(.never)
        #endif
            .autocorrectionDisabled()
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var text = ""
    VStack {
        BuildioTextField(text: $text, placeholder: "Placeholder")
        BuildioTextField(text: $text, placeholder: "Placeholder", canClear: true)
        BuildioTextField(text: $text, placeholder: "Placeholder", canPaste: true)
        BuildioTextField(text: $text, placeholder: "Placeholder", canClear: true, canPaste: true)

        BuildioTextField(text: $text, placeholder: "Placeholder", canClear: true, canPaste: true) {
            Image(.chevron_right)
        }
    }
}

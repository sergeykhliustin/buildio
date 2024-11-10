import Foundation
import SwiftUI

package extension View {
    @ViewBuilder
    func button(action: @escaping () -> Void) -> some View {
        Button(action: action, label: { self })
            .buttonStyle(.plain)
    }

    @ViewBuilder
    func submitButton(action: @escaping () -> Void) -> some View {
        Button(action: action, label: { self })
            .buttonStyle(SubmitButtonStyle())
    }

    @ViewBuilder
    func linkButton(action: @escaping () -> Void) -> some View {
        Button(action: action, label: { self })
            .buttonStyle(LinkButtonStyle())
    }
}

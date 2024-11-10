import Foundation
import SwiftUI

package extension View {
    @ViewBuilder
    func rounded(borderColor: Color = .clear, radius: CGFloat = 8) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(borderColor, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: radius))
    }
}

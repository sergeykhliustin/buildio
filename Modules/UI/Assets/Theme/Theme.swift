import SwiftUI
import Environment

private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: ThemeType = ThemeV2.default
}

package extension EnvironmentValues {
    var theme: ThemeType {
        self[ThemeEnvironmentKey.self]
    }
}

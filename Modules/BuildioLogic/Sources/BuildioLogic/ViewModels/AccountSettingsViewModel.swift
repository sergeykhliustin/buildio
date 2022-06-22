import Foundation
import SwiftUI
import Combine

public final class AccountSettingsViewModel: ObservableObject {
    @Published public var settings: AccountSettings {
        didSet {
            UserDefaults.standard.setAccountSettings(settings, for: token.email)
        }
    }
    public let token: Token

    init(token: Token) {
        self.token = token
        settings = UserDefaults.standard.accountSettings(for: token.email)
    }
}

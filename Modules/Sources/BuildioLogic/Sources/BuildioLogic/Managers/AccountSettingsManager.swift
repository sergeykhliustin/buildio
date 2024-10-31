import Foundation
import Combine
import Models

public final class AccountSettingsManager: ObservableObject {
    @Published public var accountSettings: AccountSettings! {
        didSet {
            UserDefaults.standard.setAccountSettings(accountSettings, for: account)
        }
    }
    private var tokenHandler: AnyCancellable?
    private var account: String!
    public init(_ tokenManager: TokenManager) {
        tokenHandler = tokenManager.$token.sink(receiveValue: { [weak self] token in
            guard let self = self else { return }
            guard let email = token?.email else { return }
            self.account = email
            self.accountSettings = UserDefaults.standard.accountSettings(for: email)
        })
    }

    public func isMuted(app: V0AppResponseItemModel) -> Bool {
        return accountSettings.mutedApps.contains(app.title)
    }

    public func toggleMuted(app: V0AppResponseItemModel) {
        set(app: app, isMuted: !isMuted(app: app))
    }

    public func set(app: V0AppResponseItemModel, isMuted: Bool) {
        if isMuted {
            accountSettings.mutedApps.append(app.title)
        } else {
            accountSettings.mutedApps.removeAll(where: { $0 == app.title })
        }
    }
}

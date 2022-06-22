import SwiftUI
import BuildioLogic

struct AccountSettingsScreenView: View {
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.theme) var theme
    @EnvironmentObject private var navigators: Navigators
    @EnvironmentObject private var tokenManager: TokenManager
    @EnvironmentObject private var viewModel: AccountSettingsViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.token.email)
                    .font(.headline)
                    .section()

                Text("Muted apps").section()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.bottom, 8)
        }
        .navigationTitle("Account settings")
    }
}

struct AccountSettingsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsScreenView()
    }
}

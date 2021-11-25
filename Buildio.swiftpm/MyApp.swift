import SwiftUI
import BuildioApp

@main
struct MyApp: App {
    
    var body: some Scene {
        WindowGroup {
            EnvironmentConfiguratorView {
                AuthResolverScreenView()
            }
        }
    }
}

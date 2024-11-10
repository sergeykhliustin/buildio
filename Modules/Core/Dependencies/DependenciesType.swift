import Foundation

@MainActor
package protocol DependenciesType: AnyObject {
    var apiFactory: ApiFactory { get }
    var navigator: NavigatorType { get }
    var activityProvider: ActivityProviderType { get }
    var tokenManager: TokenManagerType { get }
    var buildStatusProvider: BuildStatusProviderType { get }
}

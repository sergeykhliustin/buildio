import Foundation

@MainActor
package protocol NavigatorType {
    func show(_ path: RouteType)
    func dismiss()
}

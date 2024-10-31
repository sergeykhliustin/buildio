import Foundation
import OSLog
// swiftlint:disable:next prefixed_toplevel_constant
package let logger = Logger.shared

package class Logger: @unchecked Sendable {
    package static let shared = Logger()

    private let osLog: OSLog
    private let dateFormatter: DateFormatter

    private init() {
        osLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "BuildioLogger", category: "Default")
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
    }

    private func formatMessage(_ message: Any, _ level: OSLogType, file: String, function: String, line: Int, context: Any?) -> String {
        let date = dateFormatter.string(from: Date())
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let contextString = context.map { " - \($0)" } ?? ""
        return "\(date) \(prefix(for: level)) \(fileName).\(function):\(line)\(contextString)\n\(message)"
    }

    private func prefix(for level: OSLogType) -> String {
        switch level {
        case .debug:
            return "☑️"
        case .info:
            return "🔵"
        case .error:
            return "🔶"
        case .fault:
            return "🔴"
        default:
            return ""
        }
    }

    package func debug(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        log(.debug, message(), file, function, line: line, context: context)
    }

    package func info(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        log(.info, message(), file, function, line: line, context: context)
    }

    package func warning(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        log(.error, message(), file, function, line: line, context: context)
    }

    package func error(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        log(.fault, message(), file, function, line: line, context: context)
    }

    package func log(
        _ level: OSLogType,
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        let formattedMessage = formatMessage(message(), level, file: file, function: function, line: line, context: context)
        os_log("%{public}@", log: osLog, type: level, formattedMessage)
    }
}

import SwiftyBeaver

public final class SwiftyBeaverLogger: Logger {
    private static let swiftybeaver: SwiftyBeaver.Type = {
        if !SwiftyBeaver.destinations.contains(where: { $0 is ConsoleDestination }) {
            #if DEBUG
            let level = SwiftyBeaver.Level.verbose
            #else
            let level = SwiftyBeaver.Level.info
            #endif
    //        let console = OSLogDestination(level: level)
            let console = ConsoleDestination()
            console.asynchronously = false
            console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $X - \n $M"
            //    console.levelColor.verbose = "⚪️ "
            //    console.levelColor.debug = "☑️ "
            //    console.levelColor.info = "🔵 "
            //    console.levelColor.warning = "🔶 "
            //    console.levelColor.error = "🔴 "
            #if !DEBUG
            console.minLevel = .info
            #endif
            
            SwiftyBeaver.addDestination(console)
            
            #if DEBUG
            let file = FileDestination()
            file.logFileMaxSize = 1 * 1024 * 1024
            file.colored = true
            file.asynchronously = false
            SwiftyBeaver.addDestination(file)
            #endif
        }
        return SwiftyBeaver.self
    }()

    public override func verbose(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        Self.swiftybeaver.custom(level: .verbose, message: message(), file: file, function: function, line: line, context: context)
    }

    public override func debug(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        Self.swiftybeaver.custom(level: .debug, message: message(), file: file, function: function, line: line, context: context)
    }

    public override func info(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        Self.swiftybeaver.custom(level: .info, message: message(), file: file, function: function, line: line, context: context)
    }

    public override func warning(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        Self.swiftybeaver.custom(level: .warning, message: message(), file: file, function: function, line: line, context: context)
    }

    public override func error(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        Self.swiftybeaver.custom(level: .error, message: message(), file: file, function: function, line: line, context: context)
    }
}

//
//  Logger.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.10.2021.
//

import Foundation
import SwiftyBeaver
import os

final class OSLogDestination: BaseDestination {
    
    fileprivate var level: SwiftyBeaver.Level
    
    init(level: SwiftyBeaver.Level) {
        self.level = level
    }
    static func fileNameOfFile(_ file: String) -> String {
        let fileParts = file.components(separatedBy: "/")
        if let lastPart = fileParts.last {
            return lastPart
        }
        return ""
    }
    
    override func send(_ level: SwiftyBeaver.Level,
                       msg: String,
                       thread: String,
                       file: String,
                       function: String,
                       line: Int,
                       context: Any?) -> String? {
        
        // Be sure to log only allowed levels
        if level.rawValue >= self.level.rawValue {
            
            let log = self.createOSLog(context: context)
            let fileName = Self.fileNameOfFile(file)
            
            os_log("%@.%@:%i\n%@",
                   log: log,
                   type: self.osLogLevelRelated(to: level),
                   fileName, function, line, msg)
        }
        
        return super.send(level,
                          msg: msg,
                          thread: thread,
                          file: file,
                          function: function,
                          line: line)
    }
    
}

private extension OSLogDestination {
    
    func createOSLog(context: Any?) -> OSLog {
        var currentContext = "Default"
        if let loggerContext = context as? String {
            currentContext = loggerContext
        }
        let subsystem = Bundle.main.bundleIdentifier ?? "com.logger.default"
        let customLog = OSLog(subsystem: subsystem, category: currentContext)
        return customLog
    }
    
    func osLogLevelRelated(to swiftyBeaverLogLevel: SwiftyBeaver.Level) -> OSLogType {
        var logType: OSLogType
        switch swiftyBeaverLogLevel {
        case .debug:
            logType = .debug
        case .verbose:
            logType = .default
        case .info:
            logType = .info
        case .warning:
            // We use "error" here because of 🔶 indicator in the Console
            logType = .error
        case .error:
            // We use "fault" here because of 🔴 indicator in the Console
            logType = .fault
        }
        
        return logType
    }
}

// direct access to the logger across the app
let logger: SwiftyBeaver.Type = {
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
        file.colored = true
        file.asynchronously = false
        SwiftyBeaver.addDestination(file)
        #endif
    }
    return SwiftyBeaver.self
}()

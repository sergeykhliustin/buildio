//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import Foundation

open class BaseLogger {
    public init() { }
    open func verbose(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) { }
    open func debug(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) { }
    open func info(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) { }
    open func warning(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) { }
    open func error(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) { }
}

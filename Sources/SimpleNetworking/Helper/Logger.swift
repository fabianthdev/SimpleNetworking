//
//  Logger.swift
//  SimpleNetworking
//
//  Created by Fabian Thies on 13.01.23.
//

import Foundation

public enum LogEvent: String {
    /// ‼️ Log as an error message
    case e = "[‼️]"
    /// ℹ️ Log as an information
    case i = "[ℹ️]"
    /// 💬 Log as debug message
    case d = "[💬]"
    /// 🔬 Log as verbose message
    case v = "[🔬]"
    /// ⚠️ Log as a warning message
    case w = "[⚠️]"
    /// 🔥 Log as a severe error message
    case s = "[🔥]"
}

public class Logger {

    public class var isEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }

    private class func log(_ items: [Any], event: LogEvent, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        let itemsString = items.map({ String(describing: $0) }).joined(separator: " ")

        #if DEBUG
        if event == .i {
            Swift.print("\(event.rawValue) \(funcName) -> " + itemsString + "\n")
        } else {
            Swift.print("\(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> " + itemsString + "\n")
        }
        #endif
    }

    public class func dlog(_ message: String) {
        #if DEBUG
        Swift.print(message + "\n")
        #endif
    }

    public class func dlog(_ items: Any...) {
        #if DEBUG
        let items = items.map({ String(describing: $0) }).joined(separator: ", ")
        Swift.print(items, "\n")
        #endif
    }

    private init() {}
}


extension Logger {

    public class func e(_ items: Any..., fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        self.log(items, event: .e, fileName: fileName, line: line, column: column, funcName: funcName)
    }

    public class func i(_ items: Any..., fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        self.log(items, event: .i, fileName: fileName, line: line, column: column, funcName: funcName)
    }

    public class func d(_ items: Any..., fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        self.log(items, event: .d, fileName: fileName, line: line, column: column, funcName: funcName)
    }

    public class func v(_ items: Any..., fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        self.log(items, event: .v, fileName: fileName, line: line, column: column, funcName: funcName)
    }

    public class func w(_ items: Any..., fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        self.log(items, event: .w, fileName: fileName, line: line, column: column, funcName: funcName)
    }

    public class func s(_ items: Any..., fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        self.log(items, event: .s, fileName: fileName, line: line, column: column, funcName: funcName)
    }
}

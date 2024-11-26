    //
    //  Logs.swift
    //
    //
    //  Created by Utsav Patel on 05/09/2024.
    //

import Foundation

    /// Enum representing different log levels.
public enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

    /// A simple logging utility class that supports different log levels and timestamped log messages.
    /// This class is intended for use in debug builds only.
public class Logger {
    
        /// Singleton instance of the `Logger` class.
    public static let shared = Logger()
    
        /// The minimum log level required for messages to be logged.
        /// Messages with levels lower than this will be ignored.
    public var logLevel: LogLevel = .debug
    
    private init() {}
    
    /**
     Logs a debug message.
     
     - Parameters:
     - message: The message to log.
     - file: The file name where the log message was generated. Automatically set by the compiler.
     - line: The line number where the log message was generated. Automatically set by the compiler.
     - column: The column number where the log message was generated. Automatically set by the compiler.
     */
    public func debug(_ message: Any,
                      file: String = #file,
                      line: Int = #line,
                      column: Int = #column) {
        logMessage(message,
                   level: .debug,
                   file: file,
                   line: line,
                   column: column)
    }
    
    /**
     Logs an info message.
     
     - Parameters:
     - message: The message to log.
     - file: The file name where the log message was generated. Automatically set by the compiler.
     - line: The line number where the log message was generated. Automatically set by the compiler.
     - column: The column number where the log message was generated. Automatically set by the compiler.
     */
    public func info(_ message: Any,
                     file: String = #file,
                     line: Int = #line,
                     column: Int = #column) {
        logMessage(message,
                   level: .info,
                   file: file,
                   line: line,
                   column: column)
    }
    
    /**
     Logs a warning message.
     
     - Parameters:
     - message: The message to log.
     - file: The file name where the log message was generated. Automatically set by the compiler.
     - line: The line number where the log message was generated. Automatically set by the compiler.
     - column: The column number where the log message was generated. Automatically set by the compiler.
     */
    public func warning(_ message: Any,
                        file: String = #file,
                        line: Int = #line,
                        column: Int = #column) {
        logMessage(message,
                   level: .warning,
                   file: file,
                   line: line,
                   column: column)
    }
    
    /**
     Logs an error message.
     
     - Parameters:
     - message: The message to log.
     - file: The file name where the log message was generated. Automatically set by the compiler.
     - line: The line number where the log message was generated. Automatically set by the compiler.
     - column: The column number where the log message was generated. Automatically set by the compiler.
     */
    public func error(_ message: Any,
                      file: String = #file,
                      line: Int = #line,
                      column: Int = #column) {
        logMessage(message,
                   level: .error,
                   file: file,
                   line: line,
                   column: column)
    }
    
    private func logMessage(_ message: Any,
                            level: LogLevel,
                            file: String,
                            line: Int,
                            column: Int) {
#if DEBUG
        guard shouldLog(level: level) else { return }
        
            //        let fileName = (file as NSString).lastPathComponent
        let levelStr = level.rawValue
        let timeStr = getCurrentTimestamp()
        let lineStr = String(format: "%03d", line)
        let columnStr = String(format: "%03d", column)
        let logMessage = "[\(levelStr)] \(timeStr) (\(lineStr):\(columnStr)) - \(message)"
        
        print(logMessage)
#endif
    }
    
    private func shouldLog(level: LogLevel) -> Bool {
        switch (self.logLevel, level) {
            case (.debug, _):
                return true
            case (.info, .info), (.info, .warning), (.info, .error):
                return true
            case (.warning, .warning), (.warning, .error):
                return true
            case (.error, .error):
                return true
            default:
                return false
        }
    }
    
    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}

    //Logger.shared.debug("This is a debug message")
    //Logger.shared.info("This is an info message")
    //Logger.shared.warning("This is a warning message")
    //Logger.shared.error("This is an error message")
    //
    //Logger.shared.logLevel = .info
    //Logger.shared.debug("This debug message will not be logged")
    //Logger.shared.info("This info message will be logged")

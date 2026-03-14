//
//  AppLogr.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 2/6/26.
//

import Foundation
import os

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public final class AppLog {

    nonisolated(unsafe) public static let shared = AppLog()

    private let subsystem = Bundle.main.bundleIdentifier ?? "app.unknown"

    private var persistentLog: PersistentLog?

    private init() {}

    // MARK: - Configuration
    public func set (persistentLog: PersistentLog?) {
        self.persistentLog = persistentLog
    }

    public func enablePersistentLogging (isEnabled: Bool) {
        if isEnabled {
            self.persistentLog?.enable ()
        } else {
            self.persistentLog?.disable ()
        }
    }

    // MARK: - Core logging
    private func log (message: String, category: String) {
        // Logger sends messages that the Console App can capture. This works only when the iPhone is connected to a MacOS computer.
        let logger = Logger (subsystem: subsystem, category: category)
        logger.log (level: .default, "\(message, privacy: .public)")

        // Persist to file if configured and enabled
        if let persistentLog {
            let timestamp = Date().ISO8601Format()
            let line = "[\(timestamp)] [\(category)] \(message)"
            persistentLog.write (line)
        }
    }

    // MARK: - Public API (instance)
    public func info (_ message: String, category: String = "general") {
        log (message: "[Info]: \(message)", category: category)
    }

    public func error (_ message: String, category: String = "general") {
        log (message: "[Error]: \(message)", category: category)
    }
}

// MARK: - Static conveniences
@available(macOS 12.0, *)
@available(iOS 15.0, *)
extension AppLog {
    
    public static func info (_ message: String, category: String = "general") {
        AppLog.shared.info (message, category: category)
    }

    public static func error (_ message: String, category: String = "general") {
        AppLog.shared.error (message, category: category)
    }
    
    public static func persistentLogFileExists () -> Bool {
        return AppLog.shared.persistentLog?.logFileExists () ?? false
    }
    
    public static func clearPersistentLogFile () {
        AppLog.shared.persistentLog?.clearLogFile ()
    }
}


//
//  AppLogr.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 2/6/26.
//

import Foundation
import os

// An AppLog enum is thin layer over the Logger API. This allows to track down problems when running in developer mode, but not in the debugger.
// Logger sends messages that the Console App can capture. So this works only when the iPhone is connected to a MacOS computer.
@available(macOS 12.0, *)
@available(iOS 15.0, *)
public enum AppLog {

    private static let subsystem = Bundle.main.bundleIdentifier ?? "app.unknown"

    private static func log (
        message: String,
        persistentLog: PersistentLog? = nil,
        category: String
    ) {
        // Call the Logger. This allows to track down problems when running in developer mode, but not in the debugger.
        // Logger sends messages that the Console App can capture. This works only when the iPhone is connected to a MacOS computer.
        let logger = Logger (subsystem: subsystem, category: category)
        logger.log (level: .default, "\(message, privacy: .public)")

        // Next call the PersistentLog. This allows to track down problems when an user runs the app. The PersistentLog persists
        // messages in a file, which can then be extracted and sent for examination.
        let timestamp = Date().ISO8601Format()
        let line = "[\(timestamp)] [\(category)] \(message)"

        if let persistentLog {
            persistentLog.write (line)
        }
    }

    public static func info (_ message: String, persistentLog: PersistentLog? = nil, category: String = "general") {
        AppLog.log (message: "[Info]: \(message)", persistentLog: persistentLog, category: category)
    }

    public static func error (_ message: String, persistentLog: PersistentLog? = nil, category: String = "general") {
        AppLog.log (message: "[Error]: \(message)", persistentLog: persistentLog, category: category)
    }

}


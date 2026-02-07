//
//  AppLogr.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 2/6/26.
//

import Foundation
import os

@available(iOS 14.0, *)
@available(macOS 11.0, *)

// An AppLog enum is thin layer over the Logger API. This allows to track down problems when running in developer mode, but not in the debugger.
// Logger sends messages that the Console App can capture. So this works only when the iPhone is connected to a MacOS computer.
public enum AppLog {
    static let subsystem = Bundle.main.bundleIdentifier!

    public static func info (_ message: String, category: String = "general") {
        Logger (subsystem: subsystem, category: category).log (level: .default, "[Info]: \(message, privacy: .public)")
    }

    public static func error (_ message: String, category: String = "general") {
        Logger (subsystem: subsystem, category: category).log (level: .default, "[Error]: \(message, privacy: .public)")
    }
}


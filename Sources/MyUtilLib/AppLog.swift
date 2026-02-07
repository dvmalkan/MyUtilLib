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
public enum AppLog {
    static let subsystem = Bundle.main.bundleIdentifier!

    public static func info (_ message: String, category: String = "general") {
        Logger (subsystem: subsystem, category: category).log (level: .default, "[Info]: \(message, privacy: .public)")
    }

    public static func error (_ message: String, category: String = "general") {
        Logger (subsystem: subsystem, category: category).log (level: .default, "[Error]: \(message, privacy: .public)")
    }
}


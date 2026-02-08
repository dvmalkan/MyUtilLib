//
//  PersistentLog.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 2/7/26.
//

import Foundation

private let MAX_LOG_FILE_SIZE: UInt64 = 5_000_000  // Set at a hard-coded 5MB limit.

// PersistentLog stores messages in specified text log file. This file can then be extracted out from the user's box for examination purposes.
@available(macOS 10.15.4, *)
@available(iOS 13.4.0, *)
public final class PersistentLog {

    private let logFileName: String
    private var isEnabled: Bool = false
    
    public private(set) var fileURL: URL
    private var fileHandle: FileHandle?
    
    private var maxLogFileSizeReached: Bool = false
    
    public init (logFileName: String, enable: Bool = false) {
        self.logFileName = logFileName
        
        self.fileURL = FileManager.default.urls (for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent (logFileName)
        
        if enable {
            self.enable ()
        }
    }

    public func enable () {
        guard !isEnabled else { return }

        if !logFileExists () {
            // Create a fresh file when the file doesn't exist
            FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        }
        
        do {
            self.fileHandle = try FileHandle (forWritingTo: fileURL)
            try fileHandle?.seekToEnd ()
            isEnabled = true
        } catch {
            // Do nothing. If an error is thrown then isEnabled will remain false.
        }
    }
    
    public func disable () {
        isEnabled = false
        self.close ()
    }
    
    public func clearLogFile () {
        if !logFileExists() { return }
        
        // delete file
        do {
            try FileManager.default.removeItem (at: fileURL)
        } catch {
            // If we cannot clear the log file, then cannot do much to recover
            return
        }
        
        if isEnabled {  // Create a new fileHandle
            do {
                self.fileHandle = try FileHandle (forWritingTo: fileURL)
            } catch {
                self.fileHandle = nil
                isEnabled = false   // If we cannot recreate the fileHandle then set isEnabled to false
            }
        }
    }
    
    public func logFileExists () -> Bool {
        return FileManager.default.fileExists (atPath: fileURL.path)
    }
    
    private func close () {
        try? fileHandle?.close ()
        self.fileHandle = nil
    }

    private func writeLine (_ line: String) {
        guard isEnabled,
              let data = (line + "\n").data (using: .utf8),
              let fileHandle
        else { return }

        do {
            try fileHandle.write (contentsOf: data)
        } catch {
            // Do nothing.
        }
    }

    public func write (_ line: String) {
        guard isEnabled else { return }
        if maxLogFileSizeReached { return }
        
        writeLine (line)
        if checkIfMaxSizeReached () {
            maxLogFileSizeReached = true
            writeLine ("Max log file size reached.")
            
            // Close the file, if max file size is reached
            self.close ()
        }
    }

    private func checkIfMaxSizeReached () -> Bool {
        guard
            let attrs = try? FileManager.default.attributesOfItem (atPath: fileURL.path),
            let size = attrs[.size] as? UInt64,
            size > MAX_LOG_FILE_SIZE
        else { return false }
        
        return true
    }
}

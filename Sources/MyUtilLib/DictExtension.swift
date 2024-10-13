//
//  DictExtension.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 10/9/24.
//

public extension Dictionary where Key == String {

    // Adapted from https://stackoverflow.com/questions/33182260/case-insensitive-dictionary-in-swift
    subscript(caseInsensitive key: Key) -> Value? {
        get {
            if let firstMatch = keys.first (where: { $0.caseInsensitiveCompare(key) == .orderedSame }) {
                return self[firstMatch]
            }
            return nil
        }
        set {
            if let firstMatch = keys.first (where: { $0.caseInsensitiveCompare(key) == .orderedSame }) {
                // Update "newValue" at "firstMatch"
                self[firstMatch] = newValue
            } else {
                // If no match, then add "newValue" with "key"
                self[key] = newValue
            }
        }
    }

}

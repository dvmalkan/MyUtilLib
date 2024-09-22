//
//  StringExtension.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/22/24.
//
import Foundation

/// An extension to String
public extension String {

    // Adapted from https://stackoverflow.com/questions/32339717/how-to-remove-characters-from-a-string-in-swift
    func removeCharacters (from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }

    func removeCharacters (from: String) -> String {
        return removeCharacters (from: CharacterSet (charactersIn: from))
    }
    
    func getSubset (start: Int, end: Int) -> String {
        let startIndex = self.index (self.startIndex, offsetBy: start)
        let endIndex = self.index (self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        return String (self[range])
    }
}

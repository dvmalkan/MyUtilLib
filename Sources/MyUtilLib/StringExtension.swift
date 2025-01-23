//
//  StringExtension.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/22/24.
//
import Foundation

public enum StringMatch: Int {
    case noMatch = 0
    case partialMatch
    case wordMatch
    case exactMatch
}

/// An extension to String
public extension String {

    // Adapted from https://stackoverflow.com/questions/70118711/subscript-is-unavailable-cannot-subscript-string-with-an-int-use-a-strin
    subscript(_ idx: Int) -> Character {
        self[self.index (self.startIndex, offsetBy: idx)]
        }
    
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
    
    // Find the first match of given regular expression. Return the matched string, if found
    func regularExpressionFirstMatch (regex: NSRegularExpression) -> String? {
        let range = regex.rangeOfFirstMatch (in: self, options: [], range: NSMakeRange (0, self.utf16.count))
        if range.location == NSNotFound {
            return nil
        }
        
        return (self as NSString).substring (with: range)
    }
    
    // Compare self with 'second'. Assumption is that second has space character which need to be ignored. 'self' is assumed
    // to not have any space character.
    func matchIgnoreSpace (with second: String) -> Bool {
        let hasSpaces = second.contains (" ")
        let noSpaceSecond = hasSpaces ? second.removeCharacters(from: " ") : second
        
        return noSpaceSecond.localizedCaseInsensitiveContains (self)
    }
    
    private func matchSingle (with second: String, selfRegex: NSRegularExpression) -> StringMatch {
        // 1. First do a broad check for any match
        let hasSpaces = second.contains (" ")
        let noSpaceSecond = hasSpaces ? second.removeCharacters (from: " ") : second
            
        let anyMatch = noSpaceSecond.localizedCaseInsensitiveContains (self)
        if anyMatch == false { return .noMatch }
            
        // 2. Check for Exact Match (case-insensitive using localizedInsensitiveCompare, and ignoring spaces)
        if self.localizedCaseInsensitiveCompare (noSpaceSecond) == .orderedSame {
            return .exactMatch
        }
            
        // 3. Check for Complete Word Match (case-insensitive) using supplied Regular Expression, and without ignoring spaces
        let range = NSRange (location: 0, length: second.utf16.count)
        if selfRegex.firstMatch (in: second, options: [], range: range) != nil {
            return .wordMatch
        }
            
        // 4. Return a partialMatch
        return .partialMatch
    }
    
    // Match 'self' with 'second'. If separatorChars is not nil, then second is split into multiple words, and then 'self' is matched
    // with each 'second word'.
    func match (with second: String, separatorChars: String? = nil) -> StringMatch {
        
        // Pre-compile a regex pattern of self up-front. Just a simple potential optimization,
        // when matching with multiple 'second word's.
        let pattern = "\\b\(NSRegularExpression.escapedPattern (for: self))\\b"
        let selfRegex = try! NSRegularExpression (pattern: pattern, options: [.caseInsensitive])
        
        guard let separatorChars else { return matchSingle (with: second, selfRegex: selfRegex) }
        
        let splitSubStrings = second.split (whereSeparator: {
            for character in separatorChars {
                if $0 == character { return true }
            }
            return false
        })
        
        for splitSubstring in splitSubStrings {
            let secondString = String (splitSubstring)
            let singleMatch = self.matchSingle (with: secondString, selfRegex: selfRegex)
            if singleMatch != .noMatch { return singleMatch }
        }
        return .noMatch
    }
}

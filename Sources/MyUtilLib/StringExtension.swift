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
    // Adapted from https://stackoverflow.com/questions/28107051/convert-string-to-bool-in-swift-via-api-or-most-swift-like-approach
    var bool: Bool? {
        switch self.lowercased () {
        case "true", "t", "yes", "y":
            return true
        case "false", "f", "no", "n", "":
            return false
        default:
            if let int = Int(self) {
                return int != 0
            }
            return nil
        }
    }
    
    // Adapted from https://stackoverflow.com/questions/70118711/subscript-is-unavailable-cannot-subscript-string-with-an-int-use-a-strin
    subscript (_ idx: Int) -> Character {
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
    
    /*
    private func matchSingleOriginal (with second: String, selfRegex: NSRegularExpression) -> StringMatch {
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
        if hasSpaces {
            let noSpaceRange = NSRange (location: 0, length: noSpaceSecond.utf16.count)
            if selfRegex.firstMatch (in: noSpaceSecond, options: [], range: noSpaceRange) != nil {
                return .wordMatch
            }
        }

        // 4. Return a partialMatch
        return .partialMatch
    }
    
    // Match 'self' String with 'second' string.
    // If separatorChars is not nil, then the 'second' string is split into multiple words seperated by the given separatorChars,
    // then 'self' is matched with each such word from the 'second' String.
    func matchOriginal (with second: String, separatorChars: String? = nil) -> StringMatch {
        
        // Pre-compile a regex pattern of self up-front. Just a simple potential optimization,
        // when matching with multiple 'second word's.
        let pattern = "\\b\(NSRegularExpression.escapedPattern (for: self))\\b"
        let selfRegex = try! NSRegularExpression (pattern: pattern, options: [.caseInsensitive])
        
        guard let separatorChars else { return matchSingleOriginal (with: second, selfRegex: selfRegex) }
        
        let splitSubStrings = second.split (whereSeparator: {
            for character in separatorChars {
                if $0 == character { return true }
            }
            return false
        })
        
        for splitSubstring in splitSubStrings {
            let secondString = String (splitSubstring)
            let singleMatch = self.matchSingleOriginal (with: secondString, selfRegex: selfRegex)
            if singleMatch != .noMatch { return singleMatch }
        }
        return .noMatch
    }
     */

    private func normalizedForMatching () -> String {
        
        let allowed = CharacterSet.alphanumerics
        
        return String (
            self
                .precomposedStringWithCanonicalMapping
                .folding (options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
                .unicodeScalars
                .filter {
                    allowed.contains ($0) ||
                    CharacterSet.whitespaces.contains ($0)
                }
        )
    }
    
    private func removingWhitespace () -> String {
            String (unicodeScalars.filter {
                !CharacterSet.whitespacesAndNewlines.contains ($0)
            })
        }
    
    private func matchSingle (with second: String) -> StringMatch {
        let lhs = self.normalizedForMatching ()
        let rhs = second.normalizedForMatching ()

        // Empty strings cannot meaningfully match.
        guard !lhs.isEmpty, !rhs.isEmpty else {
            return .noMatch
        }

        // Exact match, ignoring whitespace.
        if lhs.removingWhitespace () == rhs.removingWhitespace () {
            return .exactMatch
        }

        // Word match.
        //
        // Split on anything that is neither a letter nor a number.
        // This makes punctuation, whitespace, etc. word boundaries.
        let words = rhs.split {
            !$0.isLetter && !$0.isNumber
        }

        if words.contains (where: { String ($0) == lhs }) {
            return .wordMatch
        }

        // Partial match.
        if rhs.contains (lhs) {
            return .partialMatch
        }

        return .noMatch
    }
    
    // Match 'self' String with 'second' string.
    // If separatorChars is not nil, then the 'second' string is split into multiple words seperated by the given separatorChars,
    // then 'self' is matched with each such word from the 'second' String.
    func match (with second: String, separatorChars: String? = nil) -> StringMatch {

        guard let separatorChars else {
            return matchSingle (with: second)
        }

        let separatorSet = Set (separatorChars)

        for token in second.split (whereSeparator: { separatorSet.contains($0) }) {
            let result = matchSingle (with: String(token))
            if result != .noMatch {
                return result
            }
        }

        return .noMatch
    }
}

public extension String {

    /// Attempts to match the beginning of the string against one of the supplied phrases.
    ///
    /// Matching is case-insensitive and ignores whitespace between the
    /// command and the remaining string.
    ///
    /// Example:
    ///
    ///     "Play the Beatles".matchPhrase (
    ///         from: ["Play", "Listen to", "Find"]
    ///     )
    ///
    ///     → (matched: "Play", remaining: "the Beatles")
    ///
    func matchPhrase (from phrases: [String]) -> (matched: String, remaining: String)? {

        let input = self.trimmingCharacters(in: .whitespacesAndNewlines)

        // Try longest phrases first. This is important when the list
        // contains both "Listen" and "Listen to".
        let sortedCommands = phrases.sorted {
            $0.count > $1.count
        }

        for command in sortedCommands {

            let command = command.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !command.isEmpty else {
                continue
            }

            // A command must occupy complete words. Thus "Playful"
            // must not match "Play".
            if input.count < command.count {
                continue
            }

            let prefix = String(input.prefix(command.count))

            guard prefix.caseInsensitiveCompare(command) == .orderedSame else {
                continue
            }

            // Make sure the command ends at a word boundary.
            if input.count > command.count {

                let index = input.index (input.startIndex, offsetBy: command.count)

                guard input[index].isWhitespace else {
                    continue
                }
            }

            let remainingStart = input.index(
                input.startIndex,
                offsetBy: command.count
            )

            let remaining = String (input[remainingStart...]).trimmingCharacters (in: .whitespacesAndNewlines)

            return (matched: command, remaining: remaining)
        }

        return nil
    }
}

//
//  StringExtension.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/22/24.
//
import Foundation

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
    
    // Compare self with 'matchString'. Assumption is that self has space character which need to be ignored. 'matchString' is assumed
    // to not have any space character.
    func matchIgnoreSpace (matchString: String) -> Bool {
        let hasSpaces = self.contains (" ")
        let noSpaceString = hasSpaces ? self.removeCharacters(from: " ") : self
        
        return noSpaceString.localizedCaseInsensitiveContains (matchString)
    }
}

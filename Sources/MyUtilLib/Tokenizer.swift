//
//  Tokenizer.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/22/24.
//
/// Given a string, generate an array of defined tokens.
/// Adapted from http://blog.matthewcheok.com/writing-a-lexer-in-swift/

import Foundation

public enum Token : Equatable {
    case AtomicFilter(String)
    case Number(Int)
    case ParensOpen
    case ParensClose
    case And
    case Or
    case Diff
    case Range
    case Other(String)
}

typealias TokenGenerator = (String) -> Token?
public class TokenData {
    let pattern: String
    let tokenGenerator: TokenGenerator
    let regex: NSRegularExpression?
    
    init (pattern: String, tokenGenerator: @escaping TokenGenerator) {
        self.pattern = pattern
        self.tokenGenerator = tokenGenerator
        
        // Note the ^ modifier. Match with ^pattern to match at beginning of string
        self.regex = try! NSRegularExpression (pattern: "^\(pattern)", options: [])
    }
}

public func getFilterTokenDataList () -> [TokenData] {
    return [
        TokenData (pattern: "[ \t\n]", tokenGenerator: { _ in nil }),
        TokenData (pattern: "[a-zA-Z][a-zA-Z0-9]*", tokenGenerator: { .AtomicFilter($0) }),
        TokenData (pattern: "[0-9]+", tokenGenerator: { (r: String) in .Number((r as NSString).integerValue) }),
        TokenData (pattern: "\\(", tokenGenerator: { _ in .ParensOpen }),
        TokenData (pattern: "\\)", tokenGenerator: { _ in .ParensClose }),
        TokenData (pattern: "\\&", tokenGenerator: { _ in .And }),
        TokenData (pattern: "\\|", tokenGenerator: { _ in .Or }),
        TokenData (pattern: "\\-", tokenGenerator: { _ in .Range }),
    ]
}

public class Tokenizer {
    let input: String
    

    init (input: String) {
        self.input = input
    }
    
    public func tokenize (tokenDataList: [TokenData]) -> [Token] {
        var tokens = [Token]()
        var content = input
        
        while (content.count > 0) {
            var matched = false
            
            for tokenData in tokenDataList {
                let regex = tokenData.regex
                if (regex == nil) {
                    print ("Regex is nil")
                    continue
                }
                
                if let matchedString = content.regularExpressionFirstMatch (regex: regex!) {
                    if let token = tokenData.tokenGenerator (matchedString) {
                        tokens.append (token)
                    }

                    content = content.getSubset (start: matchedString.count, end: content.count)
                    matched = true
                    break
                }
            }

            if !matched {
                tokens.append (.Other(content.getSubset(start: 0, end: 1)))
                content = content.getSubset (start: 1, end: content.count)
            }
        }
        return tokens
    }
}

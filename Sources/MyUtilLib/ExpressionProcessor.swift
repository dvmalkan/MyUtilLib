//
//  ExpressionProcessor.swift
//  my-music-app
//
//  Created by Deepak Malkan on 9/20/24.
//

import Foundation

public enum Operand : Character {
    case AND = "&"
    case OR = "|"
    case DIFF = "~"
    case RANGE = "-"
    case OPENBRACKET = "("
    case CLOSEBRACKET = ")"
    
    // Note! An array of all the operands. Be sure to update the array, if the enum changes
    static func getOperands () -> [Operand] {
        return [.AND, .OR, .DIFF, .RANGE, .OPENBRACKET, .CLOSEBRACKET]
    }
    
    static func getOperandChars () -> [Character] {
        let operands = Operand.getOperands ()
        
        var operandChars = [Character]()
        for operand in operands {
            operandChars.append(operand.rawValue)
        }
        
        return operandChars
    }
}

public class ExpressionProcessor {
    let inputExpression: String
    
    public init (inputExpression: String) {
        self.inputExpression = inputExpression
    }
    
    public static func generateTokens (inputText: String) -> [String] {
        if inputText.count <= 0 {
            return [inputText] // Return an array of an empty inputText
        }
        
        var inputIndex = 0
        var inWhiteSpace = false
        var lastNonWhiteSpaceIndex = -1
        var tokenLocations = [Int] ()
        for character in inputText {
            if inWhiteSpace {
                if character != " " { // Exiting whitespace
                    if lastNonWhiteSpaceIndex >= 0 {
                        tokenLocations.append (lastNonWhiteSpaceIndex)
                        print ("Appending token at lastNonWhiteSpaceIndex = \(lastNonWhiteSpaceIndex)")
                    }
                    inWhiteSpace = false
                } else {
                    // Skip over continuing whitespace
                    // Nothing to do
                }
            } else { // If previous character is not whiteSpace
                if character == " " { // Now entering whiteSpace
                    inWhiteSpace = true
                } else {
                    lastNonWhiteSpaceIndex = inputIndex
                    
                    for operandChar in Operand.getOperandChars () {
                        if character == operandChar {
                            tokenLocations.append (inputIndex)
                            print ("Appending token at operandChar = \(inputIndex), OperandChar = \(operandChar)")
                            inWhiteSpace = false
                            break   // for operandChar loop .. we found an operand, will not find another
                        }
                    }
                }
            }
            inputIndex += 1
        }
        
        print ("Input String = \(inputText)")
        if tokenLocations.count <= 0 {
            print ("TokenLocations is empty")
            return [inputText]
        }
        
        print ("TokenLocations = \(tokenLocations)")

        var tokens = [String] ()
        var lastTokenLocation = 0
        for tokenLocation in tokenLocations {
            let token = inputText.getSubset (start: lastTokenLocation, end: tokenLocation + 1)
            tokens.append (token.trimmingCharacters (in: .whitespaces))
            lastTokenLocation = tokenLocation + 1
        }
        if lastTokenLocation < inputText.count {
            let token = inputText.getSubset (start: lastTokenLocation, end: inputText.count)
            tokens.append (token.trimmingCharacters (in: .whitespaces))
        }
        
        if tokens.count <= 0 {
            print ("Token count is 0")
            return [inputText]
        }

        print ("Tokens are = \(tokens)")
        return tokens
    }
    
    func processExpression () {
        
    }
}

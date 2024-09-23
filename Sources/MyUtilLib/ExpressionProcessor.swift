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
    
    func processExpression () {
        
    }
}

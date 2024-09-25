//
//  ExpressionProcessor.swift
//  my-music-app
//
//  Created by Deepak Malkan on 9/20/24.
//


import Foundation

public protocol SetElement {
    func evaluateAtomicOperand (operand: String) -> Bool
    func evaluateRangeOperand (from: Int, to: Int) -> Bool
}

public class SetExpressionProcessor {
    let inputExpression: String
    let setOperators: [SetOperator]
    let rpnTokens: [SetToken]
    
    public init (inputExpression: String) {
        self.inputExpression = inputExpression
        
        let tokenizer = SetTokenizer (input: inputExpression)
        
        let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
        setOperators = getSetOperators ()
        rpnTokens = rpnGenerator.process (setOperators: setOperators)
    }
    
    public func evaluate (setElement: SetElement) throws -> Bool {
        // initialize the stack
        var stack = Stack<SetToken>()
        
        // iterating expression
        for token in rpnTokens {
            
            // token is an operand
            if token.isOperand () {
                stack.push (token)
            } else { // token is an operator
                // pop 2 operands from the stack
                let rightOperand = stack.pop ()
                let leftOperand = stack.pop ()
                
                // apply the operator to the operands
                // push the result to the stack
                switch token {
                case .And:
                    if !leftOperand!.evaluateOperand (setElement: setElement) {
                        stack.push (SetToken.False)
                    } else {
                        let result = rightOperand!.evaluateOperand (setElement: setElement)
                        stack.push (result ? SetToken.True: SetToken.False)
                    }
                case .Or:
                    if leftOperand!.evaluateOperand (setElement: setElement) {
                        stack.push (SetToken.True)
                    } else {
                        let result = rightOperand!.evaluateOperand(setElement: setElement)
                        stack.push (result ? SetToken.True: SetToken.False)
                    }
                case .Diff:
                    if !leftOperand!.evaluateOperand (setElement: setElement) {
                        stack.push (SetToken.False)
                    } else {
                        let result = rightOperand!.evaluateOperand(setElement: setElement)
                        stack.push (result ? SetToken.False: SetToken.True)
                    }
                default:
                    print ("Invalid Operator")
                }
            }
        }

        // pop the remaining value from the stack
        guard let result = stack.pop () else {
            print ("Unexpected empty stack")
            return false
        }
        
        switch result {
        case .True:
            return true
        case .False:
            return false
        case .AtomicOperand:
            return result.evaluateOperand (setElement: setElement)
        case .RangeOperand:
            return result.evaluateOperand (setElement: setElement)
        default:
            print ("Unexpected token on stack")
            return false
        }
    }
}

//
//  RPN.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/23/24.
//
/// Adapted from https://medium.com/mobilepeople/evaluating-math-expressions-with-swift-part-1-cb528ce953a5

import Foundation


class RPNGenerator {
    let tokens: [SetToken]
    
    private var numOperands = 0
    private var numOperators = 0
    private var output = [SetToken] ()
    private var stack = Stack<SetToken>()

    init (tokens: [SetToken]) {
        self.tokens = tokens
    }
    
    private func addOperatorToOutput (op: SetToken) {
        while (numOperands < numOperators + 2) {
            output.append (SetToken.DummyOperand)
            numOperands += 1
        }
        output.append (op)
        numOperators += 1
    }

    private func addOperatorToStack (op: SetToken) {
        while (numOperands < numOperators + 1) {
            output.append (SetToken.DummyOperand)
            numOperands += 1
        }
        stack.push (op)
    }

    func process (setOperators: [SetOperator]) -> [SetToken] {
        
        output = [SetToken] ()
        stack = Stack<SetToken>()
        numOperands = 0
        numOperators = 0
        
        for token in tokens {
            if token.isOperator () {
                while !stack.isEmpty && stack.peek ()!.isOperator () {
                    // while there is an operator (top) at the top of the operators stack
                    // and either (current) is left-associative and its precedence is less or equal to that of (top),
                    // or (current) is right-associative and its precedence is less than (top)
                    
                    guard let currentOperator = getOperatorForToken (operators: setOperators, token: token) else {
                        print ("RPN Error - IllegalOperator")
                        return tokens
                        // throw RPNError.IllegalOperator
                    }
                    
                    guard let topOperator = getOperatorForToken (operators: setOperators, token: stack.peek ()) else {
                        print ("RPN Error - IllegalOperator")
                        return tokens
                        // throw RPNError.IllegalOperator
                    }
                    
                    if  (currentOperator.precedence <= topOperator.precedence && currentOperator.associativity == .left) ||
                        (currentOperator.precedence < topOperator.precedence && currentOperator.associativity == .right) {
                        // pop topOperator to the output
                        addOperatorToOutput (op: stack.pop ()!)
                    } else {
                        break
                    }
                }
                
                // push the new operator to the stack
                addOperatorToStack(op: token)
                
            } else if token == SetToken.ParensOpen {
                stack.push (token)
                
            } else if token == SetToken.ParensClose {
                // while the top token (from the stack) is not open parenthesis
                while !stack.isEmpty && !(stack.peek() == SetToken.ParensOpen) {
                    // pop from the stack to the output
                    addOperatorToOutput (op: stack.pop ()!)
                }
                
                // if the stack runs out, than there are mismatched parentheses.
                if stack.isEmpty {
                    print ("RPN Error - Mismatched Parenthesis")
                    return tokens
                    // throw RPNError.MismatchedParenthesis
                }
                
                // pop the open parenthesis but don't include it in the output
                stack.pop ()
                
            } else {
                // token is a operand. Add it to the output
                output.append (token)
                numOperands += 1
            }
        }
        
        // while there are still operator tokens in the stack, pop them to output
        while !stack.isEmpty {
            addOperatorToOutput (op: stack.pop ()!)
        }
        
        print ("numOperators = \(numOperators), numOperands = \(numOperands)")
        
        return output
    }

}


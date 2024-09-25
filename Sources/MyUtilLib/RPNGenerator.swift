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
    
    init (tokens: [SetToken]) {
        self.tokens = tokens
    }
    
    func process (setOperators: [SetOperator]) -> [SetToken] {
        var output = [SetToken] ()
        var stack = Stack<SetToken>()
        
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
                        (currentOperator.precedence < topOperator.precedence && currentOperator.associativity == .right)
                    {
                        // pop it to the output
                        output.append (stack.pop ()!)
                        continue
                    }
                    break
                }
                // push the new operator to the stack
                stack.push (token)
            } else if token == SetToken.ParensOpen {
                stack.push(token)
            } else if token == SetToken.ParensClose {
                
                // while the top token (from the stack) is open parenthesis
                while !stack.isEmpty && !(stack.peek() == SetToken.ParensOpen) {
                    // pop from the stack to the output
                    output.append (stack.pop ()!)
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
                // token is not an operator or function, add it to the output
                output.append (token)
            }
        }
        
        // while there are still operator tokens in the stack, pop them to output
        while !stack.isEmpty {
            output.append (stack.pop ()!)
        }
        
        return output
    }

}


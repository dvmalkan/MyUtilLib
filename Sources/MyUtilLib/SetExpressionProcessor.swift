//
//  ExpressionProcessor.swift
//  my-music-app
//
//  Created by Deepak Malkan on 9/20/24.
//


import Foundation

public protocol SetElement {
    func evaluateAtomicOperand (operand: String) -> EvalResult
    func evaluateRangeOperand (from: Int, to: Int) -> EvalResult
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
        // first handle trivial case.
        if rpnTokens.count <= 0 {
            return true
        }
        // initialize the stack
        var stack = Stack<SetToken>()
        
        // iterating expression
        for token in rpnTokens {
            
            // token is an operand
            if token.isOperand () {
                stack.push (token)
            } else { // token is an operator
                // pop 2 operands from the stack
                guard let rightOperand = stack.pop () else {
                    print ("Right Operand is missng")
                    return false
                }
                guard let leftOperand = stack.pop () else {
                    print ("Left Operand is missing")
                    return false
                }
                
                // apply the operator to the operands
                // push the result to the stack
                switch token {
                case .And:
                    let leftEval = leftOperand.evaluateOperand (setElement: setElement)
                    if leftEval == EvalResult.False {
                        stack.push (SetToken.False)
                    } else {
                        let rightEval = rightOperand.evaluateOperand (setElement: setElement)
                        switch rightEval {
                        case .True:
                            stack.push (SetToken.True)
                        case . False:
                            stack.push (SetToken.False)
                        case .Inherit:
                            stack.push (SetToken.True)
                        }
                    }
                case .Or:
                    let leftEval = leftOperand.evaluateOperand (setElement: setElement)
                    if leftEval == EvalResult.True {
                        stack.push (SetToken.True)
                    } else {
                        let rightEval = rightOperand.evaluateOperand (setElement: setElement)
                        switch rightEval {
                        case .True:
                            stack.push (SetToken.True)
                        case . False:
                            stack.push (SetToken.False)
                        case .Inherit:
                            stack.push (leftEval == EvalResult.Inherit ? SetToken.True : SetToken.False)
                        }
                    }
                case .Diff:
                    let leftEval = leftOperand.evaluateOperand (setElement: setElement)
                    if leftEval == EvalResult.False {
                        stack.push (SetToken.False)
                    } else {
                        let rightEval = rightOperand.evaluateOperand(setElement: setElement)
                        switch rightEval {
                        case .True:
                            stack.push (SetToken.False)
                        case . False:
                            stack.push (SetToken.True)
                        case .Inherit:
                            stack.push (SetToken.True)
                        }
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
            return result.evaluateOperand (setElement: setElement) == EvalResult.True
        case .RangeOperand:
            return result.evaluateOperand (setElement: setElement) == EvalResult.True
        default:
            print ("Unexpected token on stack")
            return false
        }
    }
}

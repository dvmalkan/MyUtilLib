//
//  ExpressionProcessor.swift
//  my-music-app
//
//  Created by Deepak Malkan on 9/20/24.
//

/*
import Foundation

/// A SetExpressionProcessor takes an input expression string and processes it to evaluate a SetElement.
/// The result of the evaluation is a Bool. True means that the SetElement passes the input expression. False means that it does not.
/// The SetElement is a protocol that consists of a set of functions implemented by the caller.

public protocol SetElement {
    func evaluateAtomicOperand (operand: String) -> EvalResult
    func evaluateRangeOperand (from: Int, to: Int) -> EvalResult
    func evaluatePropertyAtomicOperand (property: String, value: String) -> EvalResult
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
    
    private func returnResultForEvalResult (evalResult: EvalResult) -> (Bool, String) {
        switch evalResult {
        case let .True(value):
            return (true, value)
        default:
            return (false, "")
        }
    }

    /// Evaluates the instance of an object that implements "setElement against "inputExpression".
    /// The result is a Bool that represents if the "setElement" passed the "inputExpression"
    /// The return "String" can contain a message that gives some details on how the "setElement" passed the "inputExpression".
    public func evaluate (setElement: SetElement) throws -> (Bool, String?) {
        // first handle trivial case.
        if rpnTokens.count <= 0 {
            return (true, "No Tokens")
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
                    return (false, "Right Operand is missing")
                }
                guard let leftOperand = stack.pop () else {
                    return (false, "Left Operand is missing")
                }
                
                // apply the operator to the operands
                // push the result to the stack
                switch token {
                case .And:
                    let leftEval = leftOperand.evaluateOperand (setElement: setElement)
                    var leftValue = ""
                    switch leftEval {
                    case EvalResult.False:
                        stack.push (SetToken.False)
                    case let EvalResult.True (value):
                        leftValue = value
                        fallthrough
                    case EvalResult.Inherit:
                        let rightEval = rightOperand.evaluateOperand (setElement: setElement)
                        switch rightEval {
                        case let .True(rightValue):
                            let valueString =  "\(leftValue) + \(rightValue)"
                            stack.push (SetToken.True (valueString))
                        case .False:
                            stack.push (SetToken.False)
                        case .Inherit:
                            stack.push (SetToken.True("Inheit"))
                        }
                    }
                case .Or:
                    let leftEval = leftOperand.evaluateOperand (setElement: setElement)
                    switch leftEval {
                    case let EvalResult.True(value):
                        stack.push (SetToken.True(value))
                    case EvalResult.False:
                        fallthrough
                    case EvalResult.Inherit:
                        let rightEval = rightOperand.evaluateOperand (setElement: setElement)
                        switch rightEval {
                        case let .True(value):
                            stack.push (SetToken.True(value))
                        case . False:
                            stack.push (SetToken.False)
                        case .Inherit:
                            switch leftEval {
                            case EvalResult.Inherit:
                                stack.push (SetToken.True("Inherit"))
                            case EvalResult.True:
                                fallthrough
                            case EvalResult.False:
                                stack.push (SetToken.False)
                            }
                        }
                    }
                case .Diff:
                    let leftEval = leftOperand.evaluateOperand (setElement: setElement)
                    var leftValue = ""
                    switch leftEval {
                    case EvalResult.False:
                        stack.push (SetToken.False)
                    case let EvalResult.True(value):
                        leftValue = value
                        fallthrough
                    case EvalResult.Inherit:
                        let rightEval = rightOperand.evaluateOperand (setElement: setElement)
                        switch rightEval {
                        case .True:
                            stack.push (SetToken.False)
                        case . False:
                            stack.push (SetToken.True(leftValue))
                        case .Inherit:
                            stack.push (SetToken.True(leftValue))
                        }
                    }
                default:
                    print ("Invalid Operator")
                }
            }
        }

        // pop the remaining value from the stack
        guard let result = stack.pop () else {
            return (false, "Unexpected empty stack")
        }
        
        switch result {
        case let .True(value):
            return (true, value)
        case .False:
            return (false, nil)
        case .AtomicOperand:
            fallthrough
        case .RangeOperand:
            fallthrough
        case .PropertyAtomicOperand:
            let evalResult = result.evaluateOperand (setElement: setElement)
            return returnResultForEvalResult (evalResult: evalResult)
        default:
            return (false, "Unexpected token on stack")
        }
    }
}

*/

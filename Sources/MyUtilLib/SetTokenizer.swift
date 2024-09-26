//
//  Tokenizer.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/22/24.
//
/// Given a string, generate an array of defined tokens.
/// Adapted from http://blog.matthewcheok.com/writing-a-lexer-in-swift/

import Foundation

public enum EvalResult {
    case True
    case False
    case Inherit
}

/// An enum that lists all the basic tokens of a set expression. A token maybe an operand or an operator.
/// An operand represents a filter. A set element either passes the filter, or does not.
/// The basic operators of a set expression are - And, Or & Diff. In addition, a set expression may consist of the ParensOpen and ParensClose tokens.
/// The True and False tokens are used by the SetExpressionProcessor to store the result of an evaluated 'set operation' on its stack
/// The DummyOperand token is used by the RPNGenerator to store a missing Operand.
public enum SetToken : Equatable {
    case AtomicOperand(String)
    case RangeOperand(Int,Int)
    case ParensOpen
    case ParensClose
    case And
    case Or
    case Diff
    case True
    case False
    case DummyOperand
    case Other(String)
    
    func toString () -> String {
        switch self {
        case let .AtomicOperand(value):
            return value
        case let .RangeOperand(value1, value2):
            return "\(value1)-\(value2)"
        case .ParensOpen:
            return SetSymbol.PARANSOPEN.toString ()
        case .ParensClose:
            return SetSymbol.PARANSCLOSE.toString ()
        case .And:
            return SetSymbol.AND.toString ()
        case .Or:
            return SetSymbol.OR.toString ()
        case .Diff:
            return SetSymbol.DIFF.toString ()
        case .True:
            return "True"
        case .False:
            return "False"
        case .DummyOperand:
            return "DummyOperand"
        case let .Other(value):
            return value
        }
    }
    
    func isOperand () -> Bool {
        switch self {
        case .AtomicOperand:
            return true
        case .RangeOperand:
            return true
        case .DummyOperand:
            return true
        default:
            return false
        }
    }
        
    func isOperator () -> Bool {
        switch self {
        case .And:
            return true
        case .Or:
            return true
        case .Diff:
            return true
        default:
            return false
        }
    }
    
    func getOperator (operators: [SetOperator]) -> SetOperator? {
        for setOperator in operators {
            if setOperator.symbol.toString() == self.toString () {
                return setOperator
            }
        }
        return nil
    }
    
    func evaluateOperand (setElement: SetElement) -> EvalResult {
        switch self {
        case let .AtomicOperand(value):
            return setElement.evaluateAtomicOperand (operand: value)
        case let .RangeOperand(value1, value2):
            return setElement.evaluateRangeOperand (from: value1, to: value2)
        case .DummyOperand:
            return .Inherit
        default:
            print ("Unexpected case for evaluate")
            return .False
        }
    }
}

typealias SetTokenGenerator = (String) -> SetToken?
class SetTokenData {
    let pattern: String
    let tokenGenerator: SetTokenGenerator
    let regex: NSRegularExpression?
    
    init (pattern: String, tokenGenerator: @escaping SetTokenGenerator) {
        self.pattern = pattern
        self.tokenGenerator = tokenGenerator
        
        // Note the ^ modifier. Match with ^pattern to match at beginning of string
        self.regex = try! NSRegularExpression (pattern: "^\(pattern)", options: [])
    }
}

func getSetTokenDataList () -> [SetTokenData] {
    return [
        SetTokenData (pattern: "[ \t\n]", tokenGenerator: { _ in nil }),
        SetTokenData (pattern: "[0-9]+[ ]*\\-[ ]*[0-9]*", tokenGenerator: {
            let numberTokens = $0.split (separator: "-", omittingEmptySubsequences: true)
            let number1 = Int (numberTokens[0].description.removeCharacters(from: " ")) ?? Int.min
            let number2 = numberTokens.count >= 2 ? Int (numberTokens[1].description.removeCharacters(from: " ")) ?? Int.max : Int.max
            return .RangeOperand (number1, number2)
        }),
        SetTokenData (pattern: "[a-zA-Z0-9]+", tokenGenerator: { .AtomicOperand ($0) }),
        SetTokenData (pattern: SetSymbol.PARANSOPEN.toStringForRegex (), tokenGenerator: { _ in .ParensOpen }),
        SetTokenData (pattern: SetSymbol.PARANSCLOSE.toStringForRegex (), tokenGenerator: { _ in .ParensClose }),
        SetTokenData (pattern: SetSymbol.AND.toStringForRegex (), tokenGenerator: { _ in .And }),
        SetTokenData (pattern: SetSymbol.OR.toStringForRegex (), tokenGenerator: { _ in .Or }),
        SetTokenData (pattern: SetSymbol.DIFF.toStringForRegex (), tokenGenerator: { _ in .Diff }),
    ]
}

class SetTokenizer {
    let input: String
    
    init (input: String) {
        self.input = input
    }
    
    func process (setTokenDataList: [SetTokenData]) -> [SetToken] {
        var tokens = [SetToken]()
        var content = input
        
        while (content.count > 0) {
            var matched = false
            
            for setTokenData in setTokenDataList {
                let regex = setTokenData.regex
                if (regex == nil) {
                    print ("Regex is nil")
                    continue
                }
                
                if let matchedString = content.regularExpressionFirstMatch (regex: regex!) {
                    if let token = setTokenData.tokenGenerator (matchedString) {
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

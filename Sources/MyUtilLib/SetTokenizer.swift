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
    case True(String)
    case False
    case Inherit
    
    func isTrue () -> Bool {
        switch self {
        case .True:
            return true
        case .False:
            return false
        case .Inherit:
            return false
        }
    }
}

/// An enum that lists all the basic tokens of a set expression. A token maybe an operand or an operator.
/// An operand represents a filter. A set element either passes the filter, or does not.
/// The basic operators of a set expression are - And, Or & Diff. In addition, a set expression may consist of the ParensOpen and ParensClose tokens.
/// The True and False tokens are used by the SetExpressionProcessor to store the result of an evaluated 'set operation' on its stack
/// The DummyOperand token is used by the RPNGenerator to store a missing Operand.
public enum SetToken : Equatable {
    case AtomicOperand(String)
    case RangeOperand(Int,Int)
    case PropertyAtomicOperand(String,String)
    case ParensOpen
    case ParensClose
    case And
    case Or
    case Diff
    case True(String)
    case False
    case DummyOperand
    case Other(String)
    
    func toString () -> String {
        switch self {
        case let .AtomicOperand(value):
            return value
        case let .RangeOperand(value1, value2):
            return "\(value1)-\(value2)"
        case let .PropertyAtomicOperand(value1, value2):
            return "\(value1):\(value2)"
        case .ParensOpen:
            return SetOperatorSymbol.PARANSOPEN.toString ()
        case .ParensClose:
            return SetOperatorSymbol.PARANSCLOSE.toString ()
        case .And:
            return SetOperatorSymbol.AND.toString ()
        case .Or:
            return SetOperatorSymbol.OR.toString ()
        case .Diff:
            return SetOperatorSymbol.DIFF.toString ()
        case let .True(value):
            return "True \(value)"
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
        case.PropertyAtomicOperand:
            return true
        case .DummyOperand:
            return true
        case .ParensOpen:
            return false
        case .ParensClose:
            return false
        case .And:
            return false
        case .Or:
            return false
        case .Diff:
            return false
        case .True:
            return false
        case .False:
            return false
        case .Other:
            return false
        }
    }
        
    func isOperator () -> Bool {
        switch self {
        case .AtomicOperand:
            return false
        case .RangeOperand:
            return false
        case.PropertyAtomicOperand:
            return false
        case .DummyOperand:
            return false
        case .ParensOpen:
            return false
        case .ParensClose:
            return false
        case .And:
            return true
        case .Or:
            return true
        case .Diff:
            return true
        case .True:
            return false
        case .False:
            return false
        case .Other:
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
        case let .PropertyAtomicOperand(value1, value2):
            return setElement.evaluatePropertyAtomicOperand (property: value1, value: value2)
        case .DummyOperand:
            return .Inherit
        case let .True(value):
            return EvalResult.True(value)
        case .False:
            return EvalResult.False
        default:
            print ("Unexpected case for evaluate")
            return .False
        }
    }
}

/// A SetTokenData instance describes a pattern that to be recognized, at the top of a given string.
/// If the pattern is recognized, then the "SetTokenGenerator" is applied on the string to generate a "SetToken"
///  "regex" is simply a cached expression associated with the pattern. "regex" is generated from "pattern" in the "init" function. A input string is matched against regex.
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

/// Returns a SetTokenData array. Its a simple loose coupling, on the premise that it gives the ability to process a different such array. For now there is only one SetTokenData array.
///  Will be useful for version management.
/// Note the dependency on SetOperatorSymbol, from where the actual set-operator charactoers are sourced.
func getSetTokenDataList () -> [SetTokenData] {
    return [
        SetTokenData (pattern: "[ \t\n]", tokenGenerator: { _ in nil }),
        SetTokenData (pattern: "[0-9]*[ ]*\\-[ ]*[0-9]*", tokenGenerator: {
            let rangeString = $0.removeCharacters(from: " ")
            let numberTokens = rangeString.split (separator: "-", omittingEmptySubsequences: true)
            var number1 = Int.min
            var number2 = Int.max
            if numberTokens.count >= 2 {
                number1 = Int (numberTokens[0].description.removeCharacters (from: " ")) ?? Int.min
                number2 = Int (numberTokens[1].description.removeCharacters(from: " ")) ?? Int.max
            }
            else if numberTokens.count == 1 {
                if rangeString[0] == "-" {
                    number2 = Int (numberTokens[0].description.removeCharacters(from: " ")) ?? Int.max
                } else if rangeString[rangeString.count - 1] == "-" {
                    number1 = Int (numberTokens[0].description.removeCharacters(from: " ")) ?? Int.min
                }
            }
            return .RangeOperand (number1, number2)
        }),
        SetTokenData (pattern: "[a-zA-Z0-9]+:[a-zA-Z0-9]*", tokenGenerator: {
            let propertyTokens = $0.split (separator: ":", omittingEmptySubsequences: true)
            let propertyName = propertyTokens[0]
            let propertyValue = propertyTokens.count >= 2 ? propertyTokens[1] : ""
            return .PropertyAtomicOperand (String (propertyName), String (propertyValue))
        }),
        SetTokenData (pattern: "[a-zA-Z0-9]+", tokenGenerator: { .AtomicOperand ($0) }),
        SetTokenData (pattern: SetOperatorSymbol.PARANSOPEN.toStringForRegex (), tokenGenerator: { _ in .ParensOpen }),
        SetTokenData (pattern: SetOperatorSymbol.PARANSCLOSE.toStringForRegex (), tokenGenerator: { _ in .ParensClose }),
        SetTokenData (pattern: SetOperatorSymbol.AND.toStringForRegex (), tokenGenerator: { _ in .And }),
        SetTokenData (pattern: SetOperatorSymbol.OR.toStringForRegex (), tokenGenerator: { _ in .Or }),
        SetTokenData (pattern: SetOperatorSymbol.DIFF.toStringForRegex (), tokenGenerator: { _ in .Diff }),
    ]
}

/// The SetTokenizer processes an "input" string and generates a "SetToken" array.
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

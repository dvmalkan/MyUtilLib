//
//  Operator.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/24/24.
//

import Foundation

enum SetOperatorSymbol: Character {
    case PARANSOPEN = "("
    case PARANSCLOSE = ")"
    case AND = "&"
    case OR = "|"
    case DIFF = "~"
    
    func toString () -> String {
        return String (self.rawValue)
    }
    
    func toStringForRegex () -> String {
        return "\\" + toString ()
    }
}

enum Associativity {
    case left
    case right
}

struct SetOperator {
    let symbol: SetOperatorSymbol
    let precedence: Int
    let associativity: Associativity
    
    init (symbol: SetOperatorSymbol, precedence: Int, associativity: Associativity) {
        self.symbol = symbol
        self.precedence = precedence
        self.associativity = associativity
    }
    
    static func < (lhs: SetOperator, rhs: SetOperator) -> Bool {
        lhs.precedence < rhs.precedence
    }
}

/// Returns a SetOperator array. Its a simple loose coupling, on the premise that it gives the ability to process a different such array. For now there is only one SetOperator array.
func getSetOperators () -> [SetOperator] {
    return [
        SetOperator (symbol: SetOperatorSymbol.AND, precedence: 0, associativity: .left),
        SetOperator (symbol: SetOperatorSymbol.OR, precedence: 0, associativity: .left),
        SetOperator (symbol: SetOperatorSymbol.DIFF, precedence: 0, associativity: .left),
    ]
}

func getOperatorForToken (operators: [SetOperator], token: SetToken?) -> SetOperator? {
    if nil == token {
        return nil
    }
    
    return token!.getOperator(operators: operators)
}


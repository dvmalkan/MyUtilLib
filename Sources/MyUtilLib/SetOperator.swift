//
//  Operator.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/24/24.
//

import Foundation

enum SetSymbol: Character {
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
    let symbol: SetSymbol
    let precedence: Int
    let associativity: Associativity
    
    init (symbol: SetSymbol, precedence: Int, associativity: Associativity) {
        self.symbol = symbol
        self.precedence = precedence
        self.associativity = associativity
    }
    
    static func < (lhs: SetOperator, rhs: SetOperator) -> Bool {
        lhs.precedence < rhs.precedence
    }
}

func getSetOperators () -> [SetOperator] {
    return [
        SetOperator (symbol: SetSymbol.AND, precedence: 0, associativity: .left),
        SetOperator (symbol: SetSymbol.OR, precedence: 0, associativity: .left),
        SetOperator (symbol: SetSymbol.DIFF, precedence: 0, associativity: .left),
    ]
}

func getOperatorForToken (operators: [SetOperator], token: SetToken?) -> SetOperator? {
    if nil == token {
        return nil
    }
    
    return token!.getOperator(operators: operators)
}


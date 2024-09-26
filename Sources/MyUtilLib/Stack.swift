//
//  Stack.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/23/24.
//

// A simple implementation of a stack as an array of elements of specified type <T>
// Adapted from https://benoitpasquier.com/data-structure-implement-stack-swift/
struct Stack<T> {
    fileprivate var elements: [T] = []
    
    mutating func push(_ item: T) {
        elements.append(item)
    }
    
    @discardableResult
    mutating func pop () -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        
        return elements.popLast()
    }
    
    func peek () -> T? {
        return elements.last
    }
    
    var isEmpty: Bool { elements.isEmpty }
}

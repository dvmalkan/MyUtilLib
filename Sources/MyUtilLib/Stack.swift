//
//  Stack.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/23/24.
//

// A simple implementation of a stack as an array of elements of specified type <T>
// Adapted from https://benoitpasquier.com/data-structure-implement-stack-swift/
public struct Stack<T> {
    public var elements: [T] = []
    
    public init () { }
    
    public mutating func push(_ item: T) {
        elements.append(item)
    }
    
    @discardableResult
    public mutating func pop () -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        
        return elements.popLast()
    }
    
    public func peek () -> T? {
        return elements.last
    }
    
    public var isEmpty: Bool { elements.isEmpty }
}

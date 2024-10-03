//
//  Queue.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/23/24.
//

// A simple implementation of a queue as an array of elements of specified type <T>
// Adapted from https://benoitpasquier.com/data-structure-implement-queue-swift/
public struct Queue<T> {
    private var elements: [T] = []
    
    public init () { }
    
    public mutating func enqueue(_ value: T) {
        elements.append(value)
    }
    
    public mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    public var head: T? {
        return elements.first
    }
    
    public var tail: T? {
        return elements.last
    }
}

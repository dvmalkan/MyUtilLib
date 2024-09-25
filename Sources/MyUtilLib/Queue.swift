//
//  Queue.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/23/24.
//

// A simple implementation of a queue as an array of elements of specified type <T>
// Adapted from https://benoitpasquier.com/data-structure-implement-queue-swift/
struct Queue<T> {
    private var elements: [T] = []
    
    mutating func enqueue(_ value: T) {
        elements.append(value)
    }
    
    mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    var head: T? {
        return elements.first
    }
    
    var tail: T? {
        return elements.last
    }
}

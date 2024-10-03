//
//  QueueTests.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 10/3/24.
//

import Testing
@testable import MyUtilLib

@Suite("Test Queue")
struct QueueTests {
    
    @Test func test1 () async throws {
        var a = Queue<Int> ()
        
        a.enqueue (1)
        a.enqueue (2)
        
        #expect(a.elements.count == 2)
        #expect(a.elements[0] == 1)
        #expect(a.elements[1] == 2)
        
        let dequeueResult = a.dequeue ()
        
        #expect(dequeueResult == 1)
        #expect(a.elements.count == 1)
        #expect(a.elements[0] == 2)
    }
}
    

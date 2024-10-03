//
//  StackTest.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 10/3/24.
//

import Testing
@testable import MyUtilLib

@Suite("Set Stack")
struct StackTests {
    
    @Test func test1 () async throws {
        var a = Stack<Int> ()
        
        a.push (1)
        a.push (2)
        
        #expect(a.elements.count == 2)
        #expect(a.elements[0] == 1)
        #expect(a.elements[1] == 2)
        
        let popResult = a.pop ()
        
        #expect(popResult == 2)
        #expect(a.elements.count == 1)
        #expect(a.elements[0] == 1)
    }
}
    


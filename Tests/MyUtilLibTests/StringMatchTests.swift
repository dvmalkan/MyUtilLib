//
//  StringContainmentTests.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 1/21/25.
//

// Example usages:
import Testing
@testable import MyUtilLib

@Suite("Test String Containment")
struct StringMatchTests {
    
    @Test func test1 () async throws {
        let result = "hello".match (with: "Hello")
        #expect (result == .exactMatch)
    }
    
    @Test func test2 () async throws {
        let result = "hello".match (with: "Hi hello world")
        #expect(result == .wordMatch)
    }
        
    @Test func test3 () async throws {
        let result = "hel".match (with: "Hello   world")
        #expect(result == .partialMatch)
    }
        
    @Test func test4 () async throws {
        let result = "hello".match (with: "hello world")
        #expect(result == .wordMatch)
    }
    
    @Test func test5 () async throws {
        let result = "goodbye".match (with: "hello world")
        #expect(result == .noMatch)
    }
    
    @Test func test6 () async throws {
        let result = "helloworld".match (with: "hello world")
        #expect(result == .exactMatch)
    }
    
    @Test func test7 () async throws {
        let result = "ow".match (with: "hello world")
        #expect(result == .partialMatch)    // Ideally this should return noMatch
    }
    
    @Test func test8 () async throws {
        let result = "world".match (with: "hello world")
        #expect(result == .wordMatch)
    }
    
    @Test func test9 () async throws {
        let result = "hithere".match (with: "hello world, hi there", separatorChars: ",")
        #expect(result == .exactMatch)
    }
    
    @Test func test10 () async throws {
        let result = "hithere".match (with: "hello world, hi there")
        #expect(result == .partialMatch)
    }
    
    @Test func test11 () async throws {
        let result = "hithere".matchIgnoreSpace (with: "hello world, hi there")
        #expect(result == true)
    }
}

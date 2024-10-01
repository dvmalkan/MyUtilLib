//
//  TokenizerTests.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/27/24.
//
// Tests to test SetTokenizer functionality

import Testing
@testable import MyUtilLib

@Suite ("Set Tokenizer")
struct SetTokenizerTests {
    
    @Test func tokenizerTestNull () async throws {
        let tokenizer = SetTokenizer (input: "")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 0)
    }
    
    @Test func tokenizerTestSample () async throws {
        let tokenizer = SetTokenizer (input: "Sample")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 1)
        #expect (tokens[0] == SetToken.AtomicOperand ("Sample"))
    }
    
    @Test func tokenizerTestAgentSample1 () async throws {
        let tokenizer = SetTokenizer (input: "Agent | Sample")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 3)
        #expect (tokens[0] == SetToken.AtomicOperand ("Agent"))
        #expect (tokens[1] == SetToken.Or)
        #expect (tokens[2] == SetToken.AtomicOperand ("Sample"))
    }
    
    @Test func tokenizerTestAgentSample2 () async throws {
        let tokenizer = SetTokenizer (input: "Agent| Sample")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 3)
        #expect (tokens[0] == SetToken.AtomicOperand ("Agent"))
        #expect (tokens[1] == SetToken.Or)
        #expect (tokens[2] == SetToken.AtomicOperand ("Sample"))
    }
    
    @Test func tokenizerTestAgentSample3 () async throws {
        let tokenizer = SetTokenizer (input: "Agent Sample")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 2)
        #expect (tokens[0] == SetToken.AtomicOperand ("Agent"))
        #expect (tokens[1] == SetToken.AtomicOperand ("Sample"))
    }
    
    @Test func tokenizerTestRange1 () async throws {
        let tokenizer = SetTokenizer (input: "1960-")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 1)
        #expect (tokens[0] == SetToken.RangeOperand (1960, Int.max))
    }
    
    @Test func tokenizerTestRange2 () async throws {
        let tokenizer = SetTokenizer (input: "-1960")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 1)
        #expect (tokens[0] == SetToken.RangeOperand (Int.min, 1960))
    }
    
    @Test func tokenizerTestRange3 () async throws {
        let tokenizer = SetTokenizer (input: "-")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 1)
        #expect (tokens[0] == SetToken.RangeOperand (Int.min, Int.max))
    }
    
    @Test func tokenizerTest1960_1970_2 () async throws {
        let tokenizer = SetTokenizer (input: "1960 - 1970")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 1)
        #expect (tokens[0] == SetToken.RangeOperand (1960, 1970))
    }
    
    @Test func tokenizerTest1960_1970_3 () async throws {
        let tokenizer = SetTokenizer (input: "1960 - 1970")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 1)
        #expect (tokens[0] == SetToken.RangeOperand (1960, 1970))
    }
    
    @Test func tokenizerTestOr1 () async throws {
        let tokenizer = SetTokenizer (input: "|")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 1)
        #expect (tokens[0] == SetToken.Or)
    }
    
    @Test func tokenizerTestOr2 () async throws {
        let tokenizer = SetTokenizer (input: "| |")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 2)
        #expect (tokens[0] == SetToken.Or)
        #expect (tokens[1] == SetToken.Or)
    }
    
    @Test func tokenizerTestAgentSample_1960_1970 () async throws {
        let tokenizer = SetTokenizer (input: "Agent | Sample | 1960-1970")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 5)
        #expect (tokens[0] == SetToken.AtomicOperand ("Agent"))
        #expect (tokens[1] == SetToken.Or)
        #expect (tokens[2] == SetToken.AtomicOperand ("Sample"))
        #expect (tokens[3] == SetToken.Or)
        #expect (tokens[4] == SetToken.RangeOperand (1960, 1970))
    }
    
    @Test func tokenizerPropValue1 () async throws {
        let tokenizer = SetTokenizer (input: "Prop:Value")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 1)
        #expect (tokens[0] == SetToken.PropertyAtomicOperand ("Prop", "Value"))
    }
    
    @Test func tokenizerPropValue2 () async throws {
        let tokenizer = SetTokenizer (input: "Prop:")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 1)
        #expect (tokens[0] == SetToken.PropertyAtomicOperand ("Prop", ""))
    }
    
    @Test func tokenizerPropValue3 () async throws {
        let tokenizer = SetTokenizer (input: "Prop: Agent")
        let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
        #expect (tokens.count == 2)
        #expect (tokens[0] == SetToken.PropertyAtomicOperand ("Prop", ""))
        #expect (tokens[1] == SetToken.AtomicOperand ("Agent"))
    }
    
}

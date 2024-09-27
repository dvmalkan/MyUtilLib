//
//  RPNGeneratorTests.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/27/24.
//
// Tests to test RPNGenerator functionality
import Testing
@testable import MyUtilLib

@Test func rpnTestSample () async throws {
    let tokenizer = SetTokenizer (input: "Sample")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.AtomicOperand ("Sample"))
}

@Test func rpnTestAgentSample1 () async throws {
    let tokenizer = SetTokenizer (input: "Agent | Sample")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 3)
    #expect (tokens[0] == SetToken.AtomicOperand ("Agent"))
    #expect (tokens[1] == SetToken.AtomicOperand ("Sample"))
    #expect (tokens[2] == SetToken.Or)
}

@Test func rpnTestAgentSample2 () async throws {
    let tokenizer = SetTokenizer (input: "Agent Sample")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 3)
    #expect (tokens[0] == SetToken.AtomicOperand ("Agent"))
    #expect (tokens[1] == SetToken.AtomicOperand ("Sample"))
    #expect (tokens[2] == SetToken.Or)
}

@Test func rpnTestAgentSampleXYZ () async throws {
    let tokenizer = SetTokenizer (input: "(Agent | Sample) & XYZ")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators ())
    
    #expect (tokens.count == 5)
    #expect (tokens[0] == SetToken.AtomicOperand ("Agent"))
    #expect (tokens[1] == SetToken.AtomicOperand ("Sample"))
    #expect (tokens[2] == SetToken.Or)
    #expect (tokens[3] == SetToken.AtomicOperand ("XYZ"))
    #expect (tokens[4] == SetToken.And)
}

@Test func rpnTestAgentA1 () async throws {
    let tokenizer = SetTokenizer (input: "A | ")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 3)
    #expect (tokens[0] == SetToken.AtomicOperand ("A"))
    #expect (tokens[1] == SetToken.DummyOperand)
    #expect (tokens[2] == SetToken.Or)
}

@Test func rpnTestAgentA2 () async throws {
    let tokenizer = SetTokenizer (input: "| A ")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 3)
    #expect (tokens[0] == SetToken.DummyOperand)
    #expect (tokens[1] == SetToken.AtomicOperand ("A"))
    #expect (tokens[2] == SetToken.Or)
}

@Test func rpnTestOr1 () async throws {
    let tokenizer = SetTokenizer (input: "|")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 3)
    #expect (tokens[0] == SetToken.DummyOperand)
    #expect (tokens[1] == SetToken.DummyOperand)
    #expect (tokens[2] == SetToken.Or)
}

@Test func rpnTestOr2 () async throws {
    let tokenizer = SetTokenizer (input: "A | B | C")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 5)
    #expect (tokens[0] == SetToken.AtomicOperand ("A"))
    #expect (tokens[1] == SetToken.AtomicOperand ("B"))
    #expect (tokens[2] == SetToken.Or)
    #expect (tokens[3] == SetToken.AtomicOperand ("C"))
    #expect (tokens[4] == SetToken.Or)
}

@Test func rpnTestOr3 () async throws {
    let tokenizer = SetTokenizer (input: "| |")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 5)
    #expect (tokens[0] == SetToken.DummyOperand)
    #expect (tokens[1] == SetToken.DummyOperand)
    #expect (tokens[2] == SetToken.Or)
    #expect (tokens[3] == SetToken.DummyOperand)
    #expect (tokens[4] == SetToken.Or)
}

@Test func rpnTestRange1 () async throws {
    let tokenizer = SetTokenizer (input: "1960-1970")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.RangeOperand(1960, 1970))
}

@Test func rpnTestRange2 () async throws {
    let tokenizer = SetTokenizer (input: "1960-")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.RangeOperand(1960, Int.max))
}

@Test func rpnTestRange3 () async throws {
    let tokenizer = SetTokenizer (input: "-1970")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.RangeOperand(Int.min, 1970))
}

@Test func rpnTestPropValue1 () async throws {
    let tokenizer = SetTokenizer (input: "Prop:Value")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.PropertyAtomicOperand ("Prop", "Value"))
}

@Test func rpnTestPropValue2 () async throws {
    let tokenizer = SetTokenizer (input: "Prop:")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.PropertyAtomicOperand ("Prop", ""))
}

@Test func rpnTestPropValue3 () async throws {
    let tokenizer = SetTokenizer (input: "Prop: Agent")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.PropertyAtomicOperand ("Prop", ""))
}





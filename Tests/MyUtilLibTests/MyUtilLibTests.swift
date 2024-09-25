import Testing
@testable import MyUtilLib

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

@Test func tokenizerTest1960_1970_1 () async throws {
    let tokenizer = SetTokenizer (input: "1960-1970")
    let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.RangeOperand (1960, 1970))
}

@Test func tokenizerTest1960_1970_2 () async throws {
    let tokenizer = SetTokenizer (input: "1960 - 1970")
    let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.RangeOperand (1960, 1970))
}

@Test func tokenizerTestAgentSample_1960_1970 () async throws {
    let tokenizer = SetTokenizer (input: "Agent | Sample | 1960-1970")
    let tokens = tokenizer.process (setTokenDataList: getSetTokenDataList ())
    #expect (tokens.count == 5)
    #expect (tokens[0] == SetToken.AtomicOperand ("Agent"))
    #expect (tokens[1] == SetToken.Or)
    #expect (tokens[2] == SetToken.AtomicOperand ("Sample"))
    #expect (tokens[3] == SetToken.Or)
    #expect (tokens[4] == SetToken.RangeOperand (1960,1970))
}

@Test func rpnTestSample () async throws {
    let tokenizer = SetTokenizer (input: "Sample")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 1)
    #expect (tokens[0] == SetToken.AtomicOperand ("Sample"))
}

@Test func rpnTestAgentSample () async throws {
    let tokenizer = SetTokenizer (input: "Agent | Sample")
    
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

class StringElement: SetElement {
    let value: String
    
    init (value: String) {
        self.value = value
    }
    
    func evaluateAtomicOperand(operand: String) -> Bool {
        return value.localizedCaseInsensitiveContains (operand)
    }
    
    func evaluateRangeOperand(from: Int, to: Int) -> Bool {
        return false
    }
}

@Test func setExpressionTestAgent1 () async throws {
    let stringElement = StringElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestAgent2 () async throws {
    let stringElement = StringElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "A ~ B")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestAgent3 () async throws {
    let stringElement = StringElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "A")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

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

@Test func rpnTestAgentOr1 () async throws {
    let tokenizer = SetTokenizer (input: "|")
    
    let rpnGenerator = RPNGenerator (tokens: tokenizer.process (setTokenDataList: getSetTokenDataList ()))
    let tokens = rpnGenerator.process (setOperators: getSetOperators())
    
    #expect (tokens.count == 3)
    #expect (tokens[0] == SetToken.DummyOperand)
    #expect (tokens[1] == SetToken.DummyOperand)
    #expect (tokens[2] == SetToken.Or)
}

@Test func rpnTestAgentOrj () async throws {
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

@Test func rpnTestAgentOr2 () async throws {
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


class SingleElement: SetElement {
    let value: String
    
    init (value: String) {
        self.value = value
    }
    
    func evaluateAtomicOperand(operand: String) -> EvalResult {
        return value.localizedCaseInsensitiveContains (operand) ? EvalResult.True : EvalResult.False
    }
    
    func evaluateRangeOperand(from: Int, to: Int) -> EvalResult {
        guard let intValue = Int (value) else { return EvalResult.False }
        return intValue >= from && intValue <= to ? EvalResult.True : EvalResult.False
    }
}

@Test func setExpressionTestAgent1 () async throws {
    let stringElement = SingleElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestAgent2 () async throws {
    let stringElement = SingleElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "A ~ B")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestAgent3 () async throws {
    let stringElement = SingleElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "A")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestAgent4 () async throws {
    let stringElement = SingleElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "A |")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestAgent5 () async throws {
    let stringElement = SingleElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: " | A")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestAgent6 () async throws {
    let stringElement = SingleElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: " | ")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestAgent7 () async throws {
    let stringElement = SingleElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: " | | ")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}


@Test func setExpressionTestAgent8 () async throws {
    let stringElement = SingleElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "A & ")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestAgent9 () async throws {
    let stringElement = SingleElement (value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "& A ")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTest1970_1 () async throws {
    let stringElement = SingleElement (value: "1970")
    let processor = SetExpressionProcessor (inputExpression: "1965-1975")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTest1970_2 () async throws {
    let stringElement = SingleElement (value: "1970")
    let processor = SetExpressionProcessor (inputExpression: "1971-1975")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == false)
}

@Test func setExpressionTest1970_3 () async throws {
    let stringElement = SingleElement (value: "1970")
    let processor = SetExpressionProcessor (inputExpression: "1975")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == false)
}

@Test func setExpressionTest1970_4 () async throws {
    let stringElement = SingleElement (value: "1970")
    let processor = SetExpressionProcessor (inputExpression: "197")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTest1970_5 () async throws {
    let stringElement = SingleElement (value: "1970")
    let processor = SetExpressionProcessor (inputExpression: "1960-")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTest1970_6 () async throws {
    let stringElement = SingleElement (value: "1970")
    let processor = SetExpressionProcessor (inputExpression: "1970-")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTest1970_7 () async throws {
    let stringElement = SingleElement (value: "1970")
    let processor = SetExpressionProcessor (inputExpression: "1971-")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == false)
}

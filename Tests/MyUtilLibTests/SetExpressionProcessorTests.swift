//
//  SetExpressionProcessorTests.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/23/24.
//
// Tests to test SetExpressionProcessor functionality
import Testing
@testable import MyUtilLib

class SingleElement: SetElement {
    let property: String
    let value: String
    
    init (value: String) {
        self.property = ""
        self.value = value
    }
    
    init (property: String, value: String) {
        self.property = property
        self.value = value
    }
    
    func evaluateAtomicOperand (operand: String) -> EvalResult {
        return self.value.localizedCaseInsensitiveContains (operand) ? EvalResult.True : EvalResult.False
    }
    
    func evaluateRangeOperand (from: Int, to: Int) -> EvalResult {
        guard let intValue = Int (self.value) else { return EvalResult.False }
        return intValue >= from && intValue <= to ? EvalResult.True : EvalResult.False
    }

    func evaluatePropertyAtomicOperand (property: String, value: String) -> EvalResult {
        if self.property != property { return EvalResult.False }
        return self.value.localizedCaseInsensitiveContains (value) ? EvalResult.True : EvalResult.False
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

@Test func setExpressionTestPropertyAgent1 () async throws {
    let stringElement = SingleElement (property: "Prop", value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestPropertyAgent2 () async throws {
    let stringElement = SingleElement (property: "Prop", value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "Prop:Agent")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestPropertyAgent3 () async throws {
    let stringElement = SingleElement (property: "Prop", value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "Prop:Ag")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == true)
}

@Test func setExpressionTestPropertyAgent4 () async throws {
    let stringElement = SingleElement (property: "Prop", value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "Prop:B")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == false)
}

@Test func setExpressionTestPropertyAgent5 () async throws {
    let stringElement = SingleElement (property: "Prop", value: "Agent")
    let processor = SetExpressionProcessor (inputExpression: "Pro:A")
    let result = try! processor.evaluate (setElement: stringElement)
    #expect (result == false)
}

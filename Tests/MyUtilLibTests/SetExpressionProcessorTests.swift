//
//  SetExpressionProcessorTests.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/23/24.
//
// Tests to test SetExpressionProcessor functionality
import Testing
@testable import MyUtilLib

@Suite ("Set Expression Processor")
struct SetExpressionProcessorTests {
    
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
            return self.value.localizedCaseInsensitiveContains (operand) ? EvalResult.True("Evaluate Atomic Operand") : EvalResult.False
        }
        
        func evaluateRangeOperand (from: Int, to: Int) -> EvalResult {
            guard let intValue = Int (self.value) else { return EvalResult.False }
            return intValue >= from && intValue <= to ? EvalResult.True("Evaluate Range Operand") : EvalResult.False
        }
        
        func evaluatePropertyAtomicOperand (property: String, value: String) -> EvalResult {
            if self.property != property { return EvalResult.False }
            return self.value.localizedCaseInsensitiveContains (value) ? EvalResult.True("Evaluate Property Atomic Operand") : EvalResult.False
        }
    }
    
    @Test(arguments: [
        ("Agent", "", true),
        ("Agent", "A", true),
        ("Agent", "A |", true),
        ("Agent", "| A", true),
        ("Agent", " | ", true),
        ("Agent", " | | ", true),
        ("Agent", "A ~ B", true),
        ("Agent", "A &", true),
        ("Agent", "& A", true),
        ("1970", "1965-1970", true),
        ("1970", "1961-1970", true),
        ("1970", "1975", false),
        ("1970", "197", true),
        ("1970", "1960-", true),
        ("1970", "1970-", true),
        ("1970", "1971-", false),
    ])
    func setExpressionSimpleTest (value: String, inputExpression: String, expectedResult: Bool) async throws {
        let stringElement = SingleElement (value: value)
        let processor = SetExpressionProcessor (inputExpression: inputExpression)
        let (result, _) = try! processor.evaluate (setElement: stringElement)
        #expect (result == expectedResult)
    }
    
    @Test(arguments: [
        ("Prop", "Agent", "", true),
        ("Prop", "Agent", "Prop:Agent", true),
        ("Prop", "Agent", "Prop:Ag", true),
        ("Prop", "Agent", "Prop:B", false),
        ("Prop", "Agent", "Pro:A", false),
        ])
    func setExpressionPropertyTest (property: String, value: String, inputExpression: String, expectedResult: Bool) async throws {
        let stringElement = SingleElement (property: property, value: value)
        let processor = SetExpressionProcessor (inputExpression: inputExpression)
        let (result, _) = try! processor.evaluate (setElement: stringElement)
        #expect (result == expectedResult)
    }
    
}

//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Adam J Leuer on 6/13/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import Foundation

func multiply(arg1: Double, arg2: Double) -> Double {
    return arg1 * arg2
}

class CalculatorBrain {
    
    private var accumulator : Double = 0.0;
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    var operations : Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation( {$1 * $0} ),
        "÷" : Operation.BinaryOperation( {$1 / $0} ),
        "+" : Operation.BinaryOperation( {$1 + $0} ),
        "−" : Operation.BinaryOperation( {$1 - $0} ),
        "=" : Operation.Equals
        
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let associatedValue): accumulator = associatedValue
                case .UnaryOperation(let function): accumulator = function(accumulator)
                case .BinaryOperation(let function):
                    executePendingBinaryOperation()
                    pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                case .Equals: executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if (pending != nil) {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}

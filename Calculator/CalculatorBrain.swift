//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Adam J Leuer on 6/13/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

func factorial(arg : Double) -> Double {

    if ((arg == 0) || (arg == 1)) {
        return arg
    }
    return arg * factorial(arg: arg - 1)
}

func flipSign(arg : Double) -> Double {
    return arg * (-1)
}


class CalculatorBrain {
    
    private var accumulator : Double = 0.0
    
    var description : String = ""
    
    var isPartialResult : Bool {
        return (pending != nil)
    }
    
    func setOperand(operand: Double) {
        description += String(operand)
        accumulator = operand
    }
    
    var operations : Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "±" : Operation.UnaryOperation(flipSign),
        "×" : Operation.BinaryOperation( {$1 * $0} ),
        "÷" : Operation.BinaryOperation( {$1 / $0} ),
        "+" : Operation.BinaryOperation( {$1 + $0} ),
        "−" : Operation.BinaryOperation( {$1 - $0} ),
        "!" : Operation.UnaryOperation(factorial),
        "abs" : Operation.UnaryOperation(abs),
        "ceil" : Operation.UnaryOperation(ceil),
        "flo" : Operation.UnaryOperation(floor),
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
            if (symbol != "=") {
                description += symbol
                //UIColor.greenColor;
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

//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Krystian Bujak on 22/05/2017.
//  Copyright © 2017 Krystian Bujak. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    var accumulator: Double?
    var pendingBinaryOperation: PendingBinaryOperation?
    
    enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func performOperation(_ secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    private let operations = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if let operand = accumulator{
                    accumulator = function(operand)
                }
            case .binaryOperation(let function):
                if let operand = accumulator{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: operand)
                    accumulator = nil
                }
            case .equals:
                if accumulator != nil && pendingBinaryOperation != nil{
                    let operand = accumulator!
                    accumulator = pendingBinaryOperation?.performOperation(operand)
                }
            }
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    var result: Double?{
        get{
            return accumulator
        }
    }
}

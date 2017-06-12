//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Krystian Bujak on 22/05/2017.
//  Copyright © 2017 Krystian Bujak. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    private var accumulator: (Double?, String?)
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var description: String?
    public var resultIsPending = false
    public var symbolIsPending = false
    public var operationAfterEqual = false
    
    enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        var firstOperand: Double
        
        func performOperation(_ secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
        
        mutating func addOperand(_ operand:Double){
            firstOperand += operand
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
                if operationAfterEqual{
                    description = nil
                    operationAfterEqual = false
                }
                accumulator.0 = value
                accumulator.1 = symbol.appending(" ")
                symbolIsPending = true
                operationDescrption = accumulator.1!
            case .unaryOperation(let function):
                if let operand = accumulator.0{
                    if operationAfterEqual{
                        accumulator.1 = operationDescrption!
                        description = nil
                        operationDescrption = symbol.appending("(").appending(accumulator.1!).appending(") ")
                        operationAfterEqual = false
                        symbolIsPending = true
                        return
                    }
                    accumulator.0 = function(operand)
                    accumulator.1 = symbol.appending("(").appending(String(operand)).appending(") ")
                    symbolIsPending = true
                    operationDescrption = accumulator.1!
                }
            case .binaryOperation(let function):
                if let operand = accumulator.0{
                    if operationAfterEqual{
                        accumulator.1 = symbol.appending(" ")
                        operationAfterEqual = false
                        operationDescrption = accumulator.1!
                    }
                    if resultIsPending{
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: pendingBinaryOperation!.performOperation(operand))
                    }else{
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: operand)
                        resultIsPending = true
                    }
                    if symbolIsPending{
                        accumulator.1 = symbol.appending(" ")
                        symbolIsPending = false
                    }else{
                        accumulator.1 = accumulator.1!.appending(symbol).appending(" ")
                    }
                    operationDescrption = accumulator.1!
                    accumulator.0 = nil
                }
            case .equals:
                if accumulator.0 != nil && pendingBinaryOperation != nil{
                    let operand = accumulator.0!
                    accumulator.0 = pendingBinaryOperation!.performOperation(operand)
                    resultIsPending = false
                    operationAfterEqual = true
                }
            }
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator.0 = operand
        accumulator.1 = String(operand).appending(" ")
    }
    
    var result: Double?{
        get{
            return accumulator.0
        }
    }
    
    
    var operationDescrption: String?{
        get{
            return description
        }
        set{
            if description != nil{
                description!.append(newValue!)
            }else{
                
                description = newValue!
            }
        }
    }
    
    
}

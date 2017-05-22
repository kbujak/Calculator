//
//  ViewController.swift
//  Calculator
//
//  Created by Krystian Bujak on 22/05/2017.
//  Copyright © 2017 Krystian Bujak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var isUserInTheMiddle = false
    var calculatorBrain = CalculatorBrain()
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }

    @IBAction func touchDigt(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if isUserInTheMiddle{
            display.text = display.text! + digit
        }else{
            display.text = digit
            isUserInTheMiddle = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        calculatorBrain.setOperand(displayValue)
        isUserInTheMiddle = false
        
        if let symbol = sender.currentTitle{
            calculatorBrain.performOperation(symbol)
        }
        
        if let result = calculatorBrain.result{
            displayValue = result
        }
    }
}


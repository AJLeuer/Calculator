//
//  ViewController.swift
//  Calculator
//
//  Created by Adam J Leuer on 6/9/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel! // = nil, set to implicitly
    
    private var userCurrentlyTyping : Bool = false
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

   @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userCurrentlyTyping {
            let currentDisplayText = self.display.text!
            display.text = currentDisplayText + digit
        }
        else {
            display.text = digit
        }
        userCurrentlyTyping = true
    }

    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userCurrentlyTyping {
            brain.setOperand(displayValue)
            userCurrentlyTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
            
        }
        displayValue = brain.result
        
    }
    
}


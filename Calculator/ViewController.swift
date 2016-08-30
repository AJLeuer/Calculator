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
    
    @IBOutlet weak var userActivityDisplay: UILabel!
    
    @IBOutlet weak var calculatorButtonsView: UIStackView!
    @IBOutlet weak var arithmeticOperationButtonsStackView: UIStackView!

    @IBOutlet weak var factorialButton: UIButton!
    
    private var userIsTyping : Bool = false

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAppearance()
    }
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private func updateUserActivityDisplay() {}
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        var digitInput = sender.currentTitle!
        if userIsTyping {
            let currentDisplayText = self.display.text!
            validateInput(currentDisplayText: currentDisplayText, digitInput: &digitInput)
            display.text = currentDisplayText + digitInput
        }
        else {
            display.text = digitInput
        }
        userIsTyping = true
    }
    
    private func validateInput(currentDisplayText : String, digitInput : inout String) {
        if (currentDisplayText.contains(".") && digitInput == ".") {
            digitInput = ""
        }
    }
    
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(operand: displayValue)
            userIsTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathSymbol)
            
        }
        displayValue = brain.result
        
    }
    
    func setAppearance() {
        
        let color0 : CGColor = UIColor(red:(225.0 / 255.0), green:(225.0 / 255.0), blue:(225.0 / 255.0), alpha:1.0).cgColor
        let color1 : CGColor = UIColor(red:(235.0 / 255.0), green:(235.0 / 255.0), blue:(235.0 / 255.0), alpha:1.0).cgColor
        let mainButtonColors : [CGColor] =  [color0, color1]
        
        let color2 : CGColor = UIColor(red:(0.0 / 255.0), green:(210.0 / 255.0), blue:(255.0 / 255.0), alpha:1.0).cgColor
        let color3 : CGColor = UIColor(red:(0.0 / 255.0), green:(200.0 / 255.0), blue:(240.0 / 255.0), alpha:1.0).cgColor
        let arithmeticButtonColors = [color2, color3]
        
        for subStackView in calculatorButtonsView.subviews as! [UIStackView] {
            for contents in  subStackView.subviews as [UIView] {
                if let button = contents as? UIButton {
                    
                    let buttonGradient : CAGradientLayer = CAGradientLayer()
                    buttonGradient.bounds = button.bounds
                    buttonGradient.frame = button.bounds
                    
                    buttonGradient.masksToBounds = true
                   
                    button.clipsToBounds = true
                    button.layer.masksToBounds = true
                    button.layer.cornerRadius = 2.5
                    
                    if (arithmeticOperationButtonsStackView.subviews.contains(button) || (button.titleLabel!.text == "±")) {
                        buttonGradient.colors = arithmeticButtonColors
                        button.layer.insertSublayer(buttonGradient, at: 1)
                    }
                    else {
                        buttonGradient.colors = mainButtonColors
                        button.layer.insertSublayer(buttonGradient, at: 1)
                    }
                }
            }
        }
        
        
        
        /*
        for contents in  arithmeticOperationButtonsStackView.subviews as [UIView] {
            if let button = contents as? UIButton {
                let buttonGradient : CAGradientLayer = CAGradientLayer()
                buttonGradient.frame = button.bounds
                buttonGradient.colors = mainButtonColors
                
                button.layer.masksToBounds = true
                //button.layer.insertSublayer(buttonGradient, atIndex: 1)
                
                //button.layer.cornerRadius = 10.0
            }
        }*/
        
    }
    
}


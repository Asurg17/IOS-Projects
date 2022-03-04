//
//  ViewController.swift
//  Ass1
//
//  Created by Aleksandre Surguladze on 13.10.21.
//

import UIKit

class ViewController: UIViewController {
    
    private let myNumber = 123
    
    @IBOutlet var firstNumber0: [UIView]!
    @IBOutlet var firstNumber1: [UIView]!
    @IBOutlet var firstNumber2: [UIView]!
    @IBOutlet var firstNumber3: [UIView]!
    @IBOutlet var firstNumber4: [UIView]!
    @IBOutlet var firstNumber5: [UIView]!
    @IBOutlet var firstNumber6: [UIView]!
    @IBOutlet var firstNumber7: [UIView]!
    @IBOutlet var firstNumber8: [UIView]!
    @IBOutlet var firstNumber9: [UIView]!
    
    @IBOutlet var secondNumber0: [UIView]!
    @IBOutlet var secondNumber1: [UIView]!
    @IBOutlet var secondNumber2: [UIView]!
    @IBOutlet var secondNumber3: [UIView]!
    @IBOutlet var secondNumber4: [UIView]!
    @IBOutlet var secondNumber5: [UIView]!
    @IBOutlet var secondNumber6: [UIView]!
    @IBOutlet var secondNumber7: [UIView]!
    @IBOutlet var secondNumber8: [UIView]!
    @IBOutlet var secondNumber9: [UIView]!
    
    @IBOutlet var thirdNumber0: [UIView]!
    @IBOutlet var thirdNumber1: [UIView]!
    @IBOutlet var thirdNumber2: [UIView]!
    @IBOutlet var thirdNumber3: [UIView]!
    @IBOutlet var thirdNumber4: [UIView]!
    @IBOutlet var thirdNumber5: [UIView]!
    @IBOutlet var thirdNumber6: [UIView]!
    @IBOutlet var thirdNumber7: [UIView]!
    @IBOutlet var thirdNumber8: [UIView]!
    @IBOutlet var thirdNumber9: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        printNumberOnCanvas(number: myNumber)
        
    }
    
    func printNumberOnCanvas(number: Int){
    
        switch number / 100 {
        case 0:
            for view in firstNumber0{
                view.backgroundColor = UIColor.red
            }
        case 1:
            for view in firstNumber1{
                view.backgroundColor = UIColor.red
            }
        case 2:
            for view in firstNumber2{
                view.backgroundColor = UIColor.red
            }
        case 3:
            for view in firstNumber3{
                view.backgroundColor = UIColor.red
            }
        case 4:
            for view in firstNumber4{
                view.backgroundColor = UIColor.red
            }
        case 5:
            for view in firstNumber5{
                view.backgroundColor = UIColor.red
            }
        case 6:
            for view in firstNumber6{
                view.backgroundColor = UIColor.red
            }
        case 7:
            for view in firstNumber7{
                view.backgroundColor = UIColor.red
            }
        case 8:
            for view in firstNumber8{
                view.backgroundColor = UIColor.red
            }
        default:
            for view in firstNumber9{
                view.backgroundColor = UIColor.red
            }
        }
        
        switch (number - 100 * (number / 100)) / 10 {
        case 0:
            for view in secondNumber0{
                view.backgroundColor = UIColor.red
            }
        case 1:
            for view in secondNumber1{
                view.backgroundColor = UIColor.red
            }
        case 2:
            for view in secondNumber2{
                view.backgroundColor = UIColor.red
            }
        case 3:
            for view in secondNumber3{
                view.backgroundColor = UIColor.red
            }
        case 4:
            for view in secondNumber4{
                view.backgroundColor = UIColor.red
            }
        case 5:
            for view in secondNumber5{
                view.backgroundColor = UIColor.red
            }
        case 6:
            for view in secondNumber6{
                view.backgroundColor = UIColor.red
            }
        case 7:
            for view in secondNumber7{
                view.backgroundColor = UIColor.red
            }
        case 8:
            for view in secondNumber8{
                view.backgroundColor = UIColor.red
            }
        default:
            for view in secondNumber9{
                view.backgroundColor = UIColor.red
            }
        }
        
        switch number % 10 {
        case 0:
            for view in thirdNumber0{
                view.backgroundColor = UIColor.red
            }
        case 1:
            for view in thirdNumber1{
                view.backgroundColor = UIColor.red
            }
        case 2:
            for view in thirdNumber2{
                view.backgroundColor = UIColor.red
            }
        case 3:
            for view in thirdNumber3{
                view.backgroundColor = UIColor.red
            }
        case 4:
            for view in thirdNumber4{
                view.backgroundColor = UIColor.red
            }
        case 5:
            for view in thirdNumber5{
                view.backgroundColor = UIColor.red
            }
        case 6:
            for view in thirdNumber6{
                view.backgroundColor = UIColor.red
            }
        case 7:
            for view in thirdNumber7{
                view.backgroundColor = UIColor.red
            }
        case 8:
            for view in thirdNumber8{
                view.backgroundColor = UIColor.red
            }
        default:
            for view in thirdNumber9{
                view.backgroundColor = UIColor.red
            }
        }
    
    }
    


}


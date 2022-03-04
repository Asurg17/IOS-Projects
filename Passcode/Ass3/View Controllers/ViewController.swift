//
//  ViewController.swift
//  Ass3
//
//  Created by Aleksandre Surguladze on 30.11.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var passcodeDot1: PasscodeDotView!
    @IBOutlet weak var passcodeDot2: PasscodeDotView!
    @IBOutlet weak var passcodeDot3: PasscodeDotView!
    @IBOutlet weak var passcodeDot4: PasscodeDotView!
    
    @IBOutlet var numButtons: [NumButtonView]!

    @IBOutlet var deleteButton: UIButton!
    
    var arr: Array<PasscodeDotView> = []
    var enteredNums: Array<Int> = [-1, -1, -1, -1]
    
    let passwordSize: Int = 4
    var enteredNumsCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNumButtonViews()
        setupPasscodeDotViews()
    }
    
    func setupNumButtonViews() {
        for numButton in numButtons {
            let buttonLabel = numButton.titleLabel!.text!
            let buttonLabelArr = buttonLabel.components(separatedBy: ":")
            
            numButton.buttonNumberLabel.text = buttonLabelArr[0]
            numButton.buttonTextLabel.text = buttonLabelArr[1]
            
            numButton.delegate = self
        }
    }
    
    func setupPasscodeDotViews() {
        arr.append(passcodeDot1)
        arr.append(passcodeDot2)
        arr.append(passcodeDot3)
        arr.append(passcodeDot4)
    }
    
    func checkIfUnlocked() {
        for currentElem in enteredNums {
            if currentElem != 1 {
                return
            }
        }
        navigateToHomeScreen()
    }
    
    func navigateToHomeScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeScreenController = mainStoryboard.instantiateViewController(withIdentifier:  "HomeScreenController")
        
        homeScreenController.modalPresentationStyle = .overFullScreen
        
        present(homeScreenController, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButtonClicked() {
        if enteredNumsCount > 0 {
            enteredNumsCount -= 1
            arr[enteredNumsCount].passcodeDot.backgroundColor = UIColor.darkGray
        }
    }

}

extension ViewController: NumButtonViewDelegate {
    
    func NumButtonViewDidTap(_ sender: NumButtonView, label: UILabel) {
        if enteredNumsCount < passwordSize {
            arr[enteredNumsCount].passcodeDot.backgroundColor = UIColor.white
            enteredNums[enteredNumsCount] = Int(label.text!)!
            
            enteredNumsCount += 1
            
            if enteredNumsCount == passwordSize {
                checkIfUnlocked()
            }
        }
    }
    
}

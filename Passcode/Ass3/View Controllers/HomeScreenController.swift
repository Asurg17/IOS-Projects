//
//  HomeScreen.swift
//  Ass3
//
//  Created by Aleksandre Surguladze on 03.12.21.
//

import UIKit

class HomeScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackgroundImage()
    }
    
    func setBackgroundImage(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }


}

//
//  ViewController.swift
//  Ass2
//
//  Created by Aleksandre Surguladze on 06.11.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var instagramImage: UIImageView!
    @IBOutlet weak var twitterImage: UIImageView!
    
    @IBOutlet weak var userInfo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setBackgroundImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        makeImagesCircular()
        makeRoundCorners()
    }
    
    func setBackgroundImage(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "stage")
        backgroundImage.contentMode = .scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }

    func makeImagesCircular(){
        profileImage.layer.cornerRadius   = profileImage.bounds.width   / 2
        facebookImage.layer.cornerRadius  = facebookImage.bounds.width  / 2
        instagramImage.layer.cornerRadius = instagramImage.bounds.width / 2
        twitterImage.layer.cornerRadius   = twitterImage.bounds.width   / 2
    }

    func makeRoundCorners(){
        userInfo.layer.cornerRadius = userInfo.bounds.width / 10
    }

}


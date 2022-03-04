//
//  PasscodeDot.swift
//  Ass3
//
//  Created by Aleksandre Surguladze on 01.12.21.
//

import UIKit

class PasscodeDotView: BaseReusableView {
    
    @IBOutlet var passcodeDot: UIView!
    
    override func layoutSubviews() {
        passcodeDot.layer.cornerRadius = self.bounds.width / 2
        passcodeDot.layer.borderWidth = 1
        passcodeDot.layer.borderColor = UIColor.white.cgColor
    }
    
}

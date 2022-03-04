//
//  NumButtonView.swift
//  Ass3
//
//  Created by Aleksandre Surguladze on 01.12.21.
//

import UIKit

protocol NumButtonViewDelegate: AnyObject {
    func NumButtonViewDidTap(_ sender: NumButtonView, label: UILabel)
}

class NumButtonView: BaseReusableView {
    
    @IBOutlet var numButtonView: UIView!
    
    @IBOutlet var buttonNumberLabel: UILabel!
    @IBOutlet var buttonTextLabel: UILabel!
    
    var delegate: NumButtonViewDelegate?
    
    override func layoutSubviews() {
        numButtonView.layer.cornerRadius = numButtonView.bounds.width / 2
        numButtonView.layer.borderWidth = 1
        numButtonView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numButtonView.backgroundColor = UIColor.lightGray
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        numButtonView.backgroundColor = UIColor.darkGray
        delegate?.NumButtonViewDidTap(self, label: buttonNumberLabel)
    }
    
}

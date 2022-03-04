//
//  ContactCell.swift
//  ContactBook
//
//  Created by Aleksandre Surguladze on 11.01.22.
//

import UIKit

class ContactCell: UICollectionViewCell {
    
    @IBOutlet var outerView: UIView!
    @IBOutlet var innerView: UIView!
    
    @IBOutlet var nameInitialsLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var firstNameLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        innerView.layer.cornerRadius = innerView.bounds.width / 2
        innerView.layer.borderWidth = 1
        innerView.layer.borderColor = UIColor.lightGray.cgColor
        
        outerView.layer.cornerRadius = 10
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func configure(with contact: Contacts){
        let wholeName = contact.name
        let arr = wholeName?.components(separatedBy: " ")
        
        var nameInitials = arr?[0].first?.uppercased() ?? ""
        if arr?.count ?? 0 > 1 {
            nameInitials += arr?[1].first?.uppercased() ?? ""
        }
        
        nameInitialsLabel.text = nameInitials
        firstNameLabel.text = arr?[0]
        numberLabel.text = contact.number
    }

}

//
//  ContactCell.swift
//  Ass4
//
//  Created by Aleksandre Surguladze on 29.12.21.
//

import UIKit

class ContactCellModel {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var isFavorite: Bool
    
    var isExpanded = false
    var height: CGFloat {
        return isExpanded ? 65 : 44
    }
    
    weak var delegate: ContactCellDelegate?

    init(firstName: String, lastName: String, phoneNumber: String, isFavorite: Bool, delegate: ContactCellDelegate?) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.isFavorite = isFavorite
        self.delegate = delegate
    }
}

protocol ContactCellDelegate: AnyObject {
    func favoriteButtonDidClick(_ contact: ContactCell)
}

class ContactCell: UITableViewCell {
    
    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private var lastNameLabel: UILabel!
    @IBOutlet private var phoneNumber: UILabel!
    
    @IBOutlet private var favoritButton: UIButton!
    
    var model: ContactCellModel!
    
    func configure(with model: ContactCellModel){
        firstNameLabel.text = model.firstName
        lastNameLabel.text = model.lastName
        phoneNumber.text = model.phoneNumber
        
        if model.isFavorite {
            favoritButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoritButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        self.model = model
    }
    
    @IBAction func handleFavoriteButtonClick() {
        model.isFavorite.toggle()
        
        if model.isFavorite {
            favoritButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoritButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        model.delegate?.favoriteButtonDidClick(self)
    }
    
}

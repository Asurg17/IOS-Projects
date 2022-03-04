//
//  ContactHeader.swift
//  Ass4
//
//  Created by Aleksandre Surguladze on 29.12.21.
//

import UIKit

class ContactHeaderModel {
    var title: String
    
    init(title: String){
        self.title = title
    }
}

class ContactHeader: UITableViewHeaderFooterView {
    
    @IBOutlet var headerTitleLabel: UILabel!
     
    func configure(with model: ContactHeaderModel){
        headerTitleLabel.text = model.title
    }
    
}

//
//  WeatherInfoHeader.swift
//  Weather App
//
//  Created by Sandro Surguladze on 09.02.22.
//

import UIKit

class WeatherInfoHeaderModel {
    var title: String
    
    init(title: String){
        self.title = title
    }
}

class WeatherInfoHeader: UITableViewHeaderFooterView {
    
    @IBOutlet var headerTitleLabel: UILabel!
     
    func configure(with model: WeatherInfoHeaderModel){
        headerTitleLabel.text = model.title
    }
    
}


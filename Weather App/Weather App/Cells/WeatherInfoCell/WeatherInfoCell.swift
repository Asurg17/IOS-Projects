//
//  WeatherInfoCell.swift
//  Weather App
//
//  Created by Sandro Surguladze on 09.02.22.
//

import UIKit

class WeatherInfoCellModel {
    var icon: String
    var time: String
    var forecast: String
    var temperature: String

    init(icon: String, time: String, forecast: String, temperature: String) {
        self.icon = icon
        self.time = time
        self.forecast = forecast
        self.temperature = temperature
    }
}


class WeatherInfoCell: UITableViewCell {
    
    @IBOutlet var forecastImage: UIImageView!
    @IBOutlet var time: UILabel!
    @IBOutlet var forecast: UILabel!
    @IBOutlet var temperature: UILabel!

    func configure(with model: WeatherInfoCellModel){
        
        forecastImage.sd_setImage(
            with: URL(string: "https://openweathermap.org/img/wn/" + model.icon + "@2x.png")
        )
        
        time.text = model.time
        forecast.text = model.forecast
        temperature.text = model.temperature + "°C"
    }
    
}

//
//  CurrentWeather.swift
//  Weather App
//
//  Created by Sandro Surguladze on 08.02.22.
//

import Foundation

// -------------CurrentWeatherResponse--------------

struct CurrentWeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let sys: Sys
    let name: String
}

// -------------Weather5DayResponse--------------

struct Weather5DayResponse: Codable {
    let list: [ListItem]
}

struct ListItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}

// -------------Other Structs--------------

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let country: String
}

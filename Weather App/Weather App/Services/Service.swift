//
//  Service.swift
//  Weather App
//
//  Created by Sandro Surguladze on 08.02.22.
//

import Foundation

class Service {
    
    private let apiKey = "2eceb8795cbbec2f81188adc59728415"
    private var components = URLComponents()
    
    init() {
        components.scheme = "https"
        components.host = "api.openweathermap.org"
    }
    
    func loadCurrentWeather(lat: String, lon: String, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> ()) {
        
        components.path = "/data/2.5/weather"
        
        let parameters = [
            "lat": lat,
            "lon": lon,
            "appid": apiKey.description,
            "units": "metric"
        ]
        
        components.queryItems = parameters.map { key, value in
           return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(
                with: request,
                completionHandler: { data, response, error in
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let response = try decoder.decode(CurrentWeatherResponse.self, from: data)
                            completion(.success(response))
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                })
            task.resume()
        } else {
            completion(.failure(ServiceError.invalidParameters))
        }
    }
    
    func load5DayWeather(lat: String, lon: String, completion: @escaping (Result<Weather5DayResponse, Error>) -> ()) {
        
        components.path = "/data/2.5/forecast"
        
        let parameters = [
            "lat": lat,
            "lon": lon,
            "appid": apiKey.description,
            "units": "metric"
        ]
        
        components.queryItems = parameters.map { key, value in
           return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(
                with: request,
                completionHandler: { data, response, error in
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let response = try decoder.decode(Weather5DayResponse.self, from: data)
                            completion(.success(response))
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                })
            task.resume()
        } else {
            completion(.failure(ServiceError.invalidParameters))
        }
    }
}

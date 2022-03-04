//
//  ViewController.swift
//  Weather App
//
//  Created by Sandro Surguladze on 03.02.22.
//

import UIKit
import CoreLocation
import SDWebImage

class FcstControllerToday: UIViewController {
    
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    @IBOutlet var weatherMainInfoStackView: UIStackView!
    @IBOutlet var weatherAdditionalInfoStackView: UIStackView!
    @IBOutlet var divider: UIView!
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var location: UILabel!
    @IBOutlet var forecast: UILabel!
    
    @IBOutlet var pctOfCloudiness: UILabel!
    @IBOutlet var moisture: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var windDirection: UILabel!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    @IBOutlet var errorImage: UIImageView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var reloadButton: UIButton!
    
    private let locationManager = CLLocationManager()
    private let service = Service()
    
    private var latitude: String?
    private var longitude: String?
    
    private var applicationError: AppError? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        if locationManager.authorizationStatus == .denied {
            applicationError = AppError.noLocationAccess
            handleError(error: nil)
        } else {
            applicationError = nil
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled(){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func setupViews() {
        reloadButton.layer.cornerRadius = 5.0
        reloadButton.clipsToBounds = true
    }
    
    func loadCurrentWeather() {
        disableBarButtons()
        hideErrorViews()
        
        if latitude == nil || longitude == nil {
            handleError(error: "No Simulator default location is selected!")
            return
        }
        
        visualEffectView.effect = UIBlurEffect(style: .regular)
        loader.startAnimating()
        service.loadCurrentWeather(lat: latitude!, lon: longitude!) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                self.visualEffectView.effect = nil
                switch result {
                case .success(let response):
                    self.handleSuccess(response: response)
                case .failure(let error):
                    self.handleError(error: error.localizedDescription.description)
                }
            }
        }
    }
    
    func setData(response: CurrentWeatherResponse) {
        weatherImage.sd_setImage(
            with: URL(string: "https://openweathermap.org/img/wn/" + response.weather[0].icon + "@2x.png")
        )
        
        location.text = response.name + ", " + response.sys.country
        forecast.text = String(Int(round(response.main.temp))) + "°C | " + response.weather[0].main
        
        pctOfCloudiness.text = String(response.clouds.all) + " %"
        moisture.text = String(response.main.humidity) + " %"
        pressure.text = String(response.main.pressure) + " hPa"
        windSpeed.text = String(round((response.wind.speed * 3.6) * 10) / 10.0) + " km/h" // 1 m/s is 3.6 km/h
        windDirection.text = response.wind.deg.direction.description
    }
    
    func handleSuccess(response: CurrentWeatherResponse) {
        hideErrorViews()
        enableBarButtons()
        showEveryView()
        setData(response: response)
    }
    
    func handleError(error: String?) {
        hideErrorViews()
        disableBarButtons()
        hideEveryView()
        showSetUpErrorViews(error: error)
    }
    
    func disableBarButtons() {
        shareButton.isEnabled = false
        
        if applicationError == .noLocationAccess {
            refreshButton.isEnabled = false
        }
    }
    
    func enableBarButtons() {
        shareButton.isEnabled = true
        refreshButton.isEnabled = true
    }
    
    func hideEveryView() {
        loader.stopAnimating()
        visualEffectView.effect = nil
        
        weatherMainInfoStackView.isHidden = true
        weatherAdditionalInfoStackView.isHidden = true
        divider.isHidden = true
    }
    
    func showEveryView() {
        weatherMainInfoStackView.isHidden = false
        weatherAdditionalInfoStackView.isHidden = false
        divider.isHidden = false
    }
    
    func showSetUpErrorViews(error: String?) {
        errorLabel.text = applicationError?.rawValue ?? error
        
        errorImage.isHidden = false
        errorLabel.isHidden = false
        
        if applicationError != AppError.noLocationAccess {
            reloadButton.isHidden = false
        }
    }
    
    func hideErrorViews() {
        errorImage.isHidden = true
        errorLabel.isHidden = true
        reloadButton.isHidden = true
    }
    
    @IBAction func refresh() {
        loadCurrentWeather()
    }
    
    @IBAction func share() {
        let items = [forecast.text ?? "Error! No Weather Fetched!"]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
    
}

extension FcstControllerToday: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus ) {
        if status == .denied {
            applicationError = AppError.noLocationAccess
            handleError(error: nil)
        } else {
            applicationError = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        if let location = locations.first {
            latitude = location.coordinate.latitude.description
            longitude = location.coordinate.longitude.description
            
            loadCurrentWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if error.localizedDescription == "The operation couldn’t be completed. (kCLErrorDomain error 0.)" {
            handleError(error: "No Simulator default location is selected!")
        } else {
            handleError(error: error.localizedDescription)
        }
    }
    
}

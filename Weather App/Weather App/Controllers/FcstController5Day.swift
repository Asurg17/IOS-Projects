//
//  ForecastController.swift
//  Weather App
//
//  Created by Sandro Surguladze on 07.02.22.
//

import UIKit
import CoreLocation
import SDWebImage

class WeatherInfoSection {
    
    var header: WeatherInfoHeaderModel?
    var weatherArr = [WeatherInfoCellModel]()
    
    var numberOfRows: Int {
        return weatherArr.count
    }
      
    init(header: WeatherInfoHeaderModel?, weatherArr: [WeatherInfoCellModel]) {
        self.header = header
        self.weatherArr = weatherArr
    }
    
}

class FcstController5Day: UIViewController {
    
    @IBOutlet var refreshButton: UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    @IBOutlet var errorImage: UIImageView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var reloadButton: UIButton!

    private let locationManager = CLLocationManager()
    private let service = Service()
    
    private var tableData = [WeatherInfoSection]()
    
    private var latitude: String?
    private var longitude: String?
    
    private var applicationError: AppError? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        if locationManager.authorizationStatus == .denied {
            applicationError = .noLocationAccess
            handleError(error: nil)
        } else {
            applicationError = nil
            initTableView()
            
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
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(
            UINib(nibName: "WeatherInfoCell", bundle: nil),
            forCellReuseIdentifier: "WeatherInfoCell"
        )
        
        tableView.register(
            UINib(nibName: "WeatherInfoHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "WeatherInfoHeader"
        )
    }
    
    func load5DayWeather() {
        disableBarButtons()
        hideErrorViews()
        
        if latitude == nil || longitude == nil {
            handleError(error: "No Simulator default location is selected!")
            return
        }
        
        tableData.removeAll()
        tableView.isHidden = true
        loader.startAnimating()
        service.load5DayWeather(lat: latitude!, lon: longitude!)  { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                switch result {
                case .success(let response):
                    self.handleSuccess(response: response)
                case .failure(let error):
                    self.handleError(error: error.localizedDescription.description)
                }
            }
        }
    }
    
    func parseResponse(list: [ListItem]) {
        var lastDay = ""
        var weatherArr = [WeatherInfoCellModel]()
        
        for (idx, listItem) in list.enumerated() {
            let currDay = getDay(dateAndTime: listItem.dt_txt)
            if idx == list.endIndex-1 {
                lastDay = currDay
                weatherArr.append(createRow(listItem: listItem))
                tableData.append(
                    createSection(
                        header: WeatherInfoHeaderModel(title: lastDay),
                        weatherArr: weatherArr
                    )
                )
                break
            } else if lastDay != "" && lastDay != currDay {
                tableData.append(
                    createSection(
                        header: WeatherInfoHeaderModel(title: lastDay),
                        weatherArr: weatherArr
                    )
                )
                weatherArr.removeAll()
            }
            
            weatherArr.append(createRow(listItem: listItem))
            lastDay = currDay
        }
    }
    
    func createRow(listItem: ListItem) -> WeatherInfoCellModel {
        let row = WeatherInfoCellModel(
            icon: listItem.weather[0].icon,
            time: getTime(dateAndTime: listItem.dt_txt),
            forecast: listItem.weather[0].description.capitalized,
            temperature: String(Int(round(listItem.main.temp)))
        )
        return row
    }
    
    func createSection(header: WeatherInfoHeaderModel, weatherArr: [WeatherInfoCellModel]) -> WeatherInfoSection {
        let section = WeatherInfoSection(
            header: header,
            weatherArr: weatherArr
        )
        return section
    }
    
    func getDay(dateAndTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateAndTime) else { return "" }

        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: date)

        return day
    }
    
    func getTime(dateAndTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateAndTime) else { return "" }

        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: date)

        return time
    }
    
    func handleSuccess(response: Weather5DayResponse) {
        hideErrorViews()
        enableBarButtons()
        showEveryView()
        
        parseResponse(list: response.list) //es raime meore thread shi xom ar unda gaketdes ?
        tableView.reloadData()
    }
    
    func handleError(error: String?) {
        disableBarButtons()
        hideEveryView()
        showSetUpErrorViews(error: error)
    }
    
    func disableBarButtons() {
        if applicationError == .noLocationAccess {
            refreshButton.isEnabled = false
        }
    }
    
    func enableBarButtons() {
        refreshButton.isEnabled = true
    }
    
    func hideEveryView() {
        loader.stopAnimating()
        tableView.isHidden = true
    }
    
    func showEveryView() {
        self.tableView.isHidden = false
    }
    
    func showSetUpErrorViews(error: String?) {
        errorLabel.text = applicationError?.rawValue ?? error
        
        errorImage.isHidden = false
        errorLabel.isHidden = false
        
        if applicationError != .noLocationAccess {
            reloadButton.isHidden = false
        }
    }
    
    func hideErrorViews() {
        errorImage.isHidden = true
        errorLabel.isHidden = true
        reloadButton.isHidden = true
    }
    
    @IBAction func refresh() {
        hideErrorViews()
        load5DayWeather()
    }
    
}

extension FcstController5Day: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerModel = tableData[section].header else { return nil}

        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeatherInfoHeader")

        if let contactHeader = header as? WeatherInfoHeader {
            contactHeader.configure(with: headerModel)
        }

        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "WeatherInfoCell",
            for: indexPath
        )

        if let contactCell = cell as? WeatherInfoCell {
            contactCell.configure(with: tableData[indexPath.section].weatherArr[indexPath.row])
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

extension FcstController5Day: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        if let location = locations.first {
            latitude = location.coordinate.latitude.description
            longitude = location.coordinate.longitude.description
            
            load5DayWeather()
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

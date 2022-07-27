

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var isHourly = true {
        didSet {
            weatherCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
        getCurrentDate()
        checkLocationAuthStatus()
        fetchWeatherData()
    }
    
    //MARK: - GetCurrentDate
    func getCurrentDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    //MARK: - CheckLocationStatus
    func checkLocationAuthStatus() {
        if LocationService.shared.locationManager.authorizationStatus == .authorizedWhenInUse {
            LocationService.shared.customUserLocationDelegate = self
        } else {
            LocationService.shared.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK: - FetchWeatherData
    func fetchWeatherData() {
        NetworkManager.shared.fetchWeatherData { [weak self] result in
            switch result {
            case .success(let weather):
                self?.conditionLabel.text = weather.description
                self?.conditionImageView.image = UIImage(named: weather.iconName)
                self?.temperatureLabel.text = "\(weather.temperature)℉"
                self?.weatherCollectionView.reloadData()
            case .failure(let error):
                presentAlert(vc: self!, title: "Something Went Wrong 😭", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    //MARK: - GetCityName
    func getCityName() {
        guard let exposedLocation = LocationService.shared.exposedLocation else {
            print(LocationError.requestFailed.rawValue)
            return
        }
        LocationService.shared.getPlace(for: exposedLocation) { [weak self] result in
            switch result {
            case .success(let placemark):
                let city = placemark?.locality
                self?.locationLabel.text = city
            case .failure(let error):
                presentAlert(vc: self!, title: "Something Went Wrong 😭", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    //MARK: - HourlyWeather
    @IBAction func hourlyTapped(_ sender: UIButton) {
        isHourly = true
    }
    
    //MARK: - DailyWeather
    @IBAction func dailyTapped(_ sender: UIButton) {
        isHourly = false
    }
}

//MARK: - CollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(NetworkManager.shared.dailyArray.count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell {
            if isHourly == true {
                cell.updateHourlyView(response: NetworkManager.shared.hourlyArray[indexPath.row])
            } else {
                cell.updateDailyView(response: NetworkManager.shared.dailyArray[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - CollectionViewDelagate
extension WeatherViewController: UICollectionViewDelegate {
    
}

//MARK: - CustomUserLocationDelegate
extension WeatherViewController: CustomUserLocationDelegate {
    func userLocationUpdated(location: CLLocation) {
        NetworkManager.shared.makeDataRequest(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        getCityName()
    }
}
//MARK: - UIAlert
func presentAlert(vc: UIViewController, title: String, message: String, buttonTitle: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
    vc.present(alert, animated: true)
}

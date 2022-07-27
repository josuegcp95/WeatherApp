

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var condImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    public func updateHourlyView(response: APIHourly) {
        let date = Date(timeIntervalSince1970: Double(response.date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        dateLabel.text = dateFormatter.string(from: date)
        condImageView.image = UIImage(named: response.weather.first?.icon ?? "")
        tempLabel.text = "\(Int(response.temp))℉"
    }
    
    public func updateDailyView(response: APIDaily) {
        let date = Date(timeIntervalSince1970: Double(response.date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        dateLabel.text = dateFormatter.string(from: date)
        condImageView.image = UIImage(named: response.weather.first?.icon ?? "")
        tempLabel.text = "\(Int(response.temp.temp))℉"
    }
}



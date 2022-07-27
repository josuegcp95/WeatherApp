

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    let apiKey = "af439b427c0c50ee092b1e545de8a2d4"
    var hourlyArray = [APIHourly] ()
    var dailyArray = [APIDaily] ()
    var completionHandler: ((Result<Weather, APIError>) -> Void)?
    let session = URLSession(configuration: .default)
    
    public func fetchWeatherData(_ completionHandler: @escaping (Result<Weather, APIError>) -> Void) {
        self.completionHandler = completionHandler
    }
    
    public func makeDataRequest(lat: Double, lon: Double) {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/onecall?")!
        urlComponents.queryItems = [
            "lat": "\(lat)",
            "lon": "\(lon)",
            "appid": "\(apiKey)",
            "units": "imperial"
        ].map {URLQueryItem(name: $0.key, value: $0.value)}
        
        let task = session.dataTask(with: urlComponents.url!) { data, response, error in
            
            DispatchQueue.main.async {
                if let _ = error {
                    self.completionHandler?(.failure(APIError.requestFailed))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    self.completionHandler?(.failure(APIError.invalidResponse))
                    return }
                
                guard let data = data else {
                    self.completionHandler?(.failure(APIError.invalidData))
                    return }
    
                do {
                    if response.statusCode == 200 {
                        let response = try JSONDecoder().decode(APIResponse.self, from: data)
                        self.hourlyArray = response.hourly
                        self.dailyArray = response.daily
                        self.completionHandler?(.success(Weather(response: response)))
                    }
                }
                catch {
                    self.completionHandler?(.failure(APIError.invalidData))
                }
            }
        }
        task.resume()
    }
}

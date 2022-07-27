

import Foundation

//MARK: - MAIN MODELS
struct APIResponse: Codable {
    var current: APICurrent
    var hourly: [APIHourly]
    var daily: [APIDaily]
    
    private enum CodingKeys: String, CodingKey {
        case current
        case hourly
        case daily
        
    }
}

//MARK: - CURRENT WEATHER MODELS
struct APICurrent: Codable {
    var weather: [APICurrentWeather]
    var temp: Double
    
    private enum CodingKeys: String, CodingKey {
        case weather
        case temp
    }
}

struct APICurrentWeather: Codable {
    var description: String
    var icon: String
    
    private enum CodingKeys: String, CodingKey {
        case description
        case icon
    }
}

//MARK: - HOURLY WEATHER MODELS
struct APIHourly: Codable {
    var date: Int
    var weather: [APIHourlyWeather]
    var temp: Double
    
    private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weather
        case temp
    }
}

struct APIHourlyWeather: Codable {
    var icon: String
    
    private enum CodingKeys: String, CodingKey {
        case icon
    }
}

//MARK: - DAILY WEATHER MODELS
struct APIDaily: Codable {
    var date: Int
    var weather: [APIDailyWeather]
    var temp: APIDailyTemperature
    
    private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weather
        case temp
    }
}

struct APIDailyWeather: Codable {
    var icon: String
    
    private enum CodingKeys: String, CodingKey {
        case icon
    }
}

struct APIDailyTemperature: Codable {
    var temp: Double
    
    private enum CodingKeys: String, CodingKey {
        case temp = "day"
    }
}

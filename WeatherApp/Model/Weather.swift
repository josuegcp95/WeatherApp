

import Foundation

public struct Weather {
    let description: String
    let iconName: String
    let temperature: Int
    
    init(response: APIResponse) {
        description = response.current.weather.first?.description ?? ""
        iconName = response.current.weather.first?.icon ?? ""
        temperature = Int(response.current.temp)
    }
}

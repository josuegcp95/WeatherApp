

import Foundation

enum LocationError: String, Error {
    case requestFailed = "Couldn't complete your request. Please check your internet connection."
    case accessDenied = "Couldn't access your location. Please change your settings."
}

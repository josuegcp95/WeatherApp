

import Foundation

enum APIError: String, Error {
    case requestFailed = "Couldn't complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response received from the server. Please try again."
    case invalidData = "Invalid data received from the server. Please try again."
}

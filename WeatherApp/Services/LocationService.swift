

import Foundation
import CoreLocation

protocol CustomUserLocationDelegate: AnyObject {
    func userLocationUpdated(location: CLLocation)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    var locationManager = CLLocationManager()
    var exposedLocation: CLLocation?
    weak var customUserLocationDelegate: CustomUserLocationDelegate?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.exposedLocation = locations.first
        if customUserLocationDelegate != nil {
            customUserLocationDelegate?.userLocationUpdated(location: locations.first!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error.localizedDescription)
    }
    
    public func getPlace(for location: CLLocation, completion: @escaping (Result<CLPlacemark?, LocationError>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                completion(.failure(LocationError.requestFailed))
                return
            }
            
            guard let placemark = placemarks?[0] else {
                completion(.failure(LocationError.accessDenied))
                return
            }
            completion(.success(placemark))
        }
    }
}

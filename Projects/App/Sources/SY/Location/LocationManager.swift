// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import CoreLocation

struct Location {
    var crdntX: Double
    var crdntY: Double
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    var userLocationInto = Location(crdntX: 0.0, crdntY: 0.0)
    
    @Published var userLocation: CLLocation?
    @Published var locationString: String = "Fetching location..."
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func fetchUserLocation() {
        self.locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        self.userLocation = userLocation
        manager.stopUpdatingLocation()
        
        // Display latitude and longitude
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        locationString = "Latitude: \(latitude), Longitude: \(longitude)"
        
        userLocationInto.crdntY = latitude
        userLocationInto.crdntX = longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        locationString = "Failed to fetch location"
    }
    
//    func calculateDistance(userLocation: Location, targetLocation: StationLocation) -> Double? {
//        let userLatitude = Double(userLocation.crdntY)
//        let userLongitude = Double(userLocation.crdntX)
//        let targetLatitude = Double(targetLocation.crdntY)
//        let targetLongitude = Double(targetLocation.crdntX)
//
//        let earthRadius: Double = 6371 // Radius of the Earth in kilometers
//
//        let deltaLat = (targetLatitude - userLatitude).toRadians()
//        let deltaLon = (targetLongitude - userLongitude).toRadians()
//
//        let a = sin(deltaLat / 2) * sin(deltaLat / 2) +
//                cos(userLatitude.toRadians()) * cos(targetLatitude.toRadians()) *
//                sin(deltaLon / 2) * sin(deltaLon / 2)
//
//        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
//
//        let distance = earthRadius * c
//        return distance
//    }
    
    func findClosestStation(userLocation: Location, stationLocations: [StationLocation]) -> StationLocation? {
        guard !stationLocations.isEmpty else {
            return nil // Return nil if there are no stations
        }

        var closestStation: StationLocation?
        var minDifference: Double = Double.infinity
        
        for station in stationLocations {
            let diffX = abs(station.crdntX - userLocation.crdntX)
            let diffY = abs(station.crdntY - userLocation.crdntY)
            
            let totalDifference = diffX + diffY
            
            if totalDifference < minDifference {
                minDifference = totalDifference
                closestStation = station
            }
        }
        
        return closestStation
    }
}

extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
}

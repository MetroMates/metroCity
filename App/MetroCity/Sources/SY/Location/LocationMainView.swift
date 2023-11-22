// Copyright © 2023 TDS. All rights reserved. 2023-11-21 화 오후 03:25 꿀꿀🐷

import SwiftUI
import CoreLocation
import Alamofire

struct LocationMainView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LocationMainView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMainView()
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }

        // 현재 위치의 위도와 경도
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude

        // 역의 위치 (예시로 1개의 역을 설정)
        let stationLatitude = 37.12345
        let stationLongitude = 127.56789

        // 거리 계산
        let distance = calculateDistance(lat1: currentLatitude, lon1: currentLongitude, lat2: stationLatitude, lon2: stationLongitude)

        // 1km 반경 내에 있는지 확인
        if distance <= 1000 {
            print("가까운 역이 있습니다.")
        } else {
            print("가까운 역이 없습니다.")
        }
    }

    private func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let coordinate1 = CLLocation(latitude: lat1, longitude: lon1)
        let coordinate2 = CLLocation(latitude: lat2, longitude: lon2)
        return coordinate1.distance(from: coordinate2)
    }
}

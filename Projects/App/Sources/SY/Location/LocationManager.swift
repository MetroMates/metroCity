// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import CoreLocation

struct Location {
    var crdntX: Double
    var crdntY: Double
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    
    @Published var locationString: String = "Fetching location..."
    @Published var userLocationInto = Location(crdntX: 0.0, crdntY: 0.0)
    @Published var distacneArray: [Double] = []
    @Published var stationArray: [String] = []
    
    override init() {
        super.init()
        // CLLocationManager의 대리자를 self로 설정 -> LocationManager 클래스가 위치 서비스와 관련된 업데이트 및 이벤트를 처리한다는 것을 나타냄
        self.locationManager.delegate = self
        
        // 포그라운드에 있는동안 위치 서비스를 사용할 수 있는 권한을 사용자에게 요청 (개인정보와 관련하여.. 앱 사용중일 때 위치 정보에 엑세스 할수 있다는 의미)
        // 해당 항목은 plist의 privacy 키값에 의해 제어됨
        self.locationManager.requestWhenInUseAuthorization()
        
        // 대리인(self)에게 위치 없데이트 전달을 시작함 -> delegate 채택으로 인하여 정의한 didUpdateLocations 대리자 메서드는 사용 가능한 새 위치 데이터가 있을 때마다 호출됩니다.

        self.locationManager.startUpdatingLocation()
    }
    
    func fetchUserLocation() {
        self.locationManager.requestLocation()
    }
    
    /// delegate 관련 정의 함수
    /// 이 메소드는 새로운 위치 데이터를 사용할 수 있을 때 호출됩니다. 사용자의 업데이트된 위치를 나타내는 CLLocation 개체 배열을 제공합니다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return } // 사용자 위치가 nil인지 아닌지 판단

        manager.stopUpdatingLocation()

        // 위도(latitude-37)와 경도(longitude-126) 추출하기
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        locationString = "Latitude: \(latitude), Longitude: \(longitude)"

        userLocationInto.crdntY = latitude
        userLocationInto.crdntX = longitude
    }
    
    /// delegate 관련 정의 함수
    /// 위치 관리자가 사용자의 위치를 ​​가져오는 중 오류가 발생하면 이 메소드가 호출됩니다.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        locationString = "Failed to fetch location"
    }
    
    /// 위경도 값 기준 가장 가까운 거리의 역 찾기
    func findClosestStation(userLocation: Location, stationLocations: [StationLocation]) -> StationLocation? {
        guard !stationLocations.isEmpty else {
            return nil
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
                self.distacneArray.append(totalDifference)
//                self.stationArray.append(closestStation?.statnNm ?? "⭐️")
            }
            self.stationArray.append(closestStation?.statnNm ?? "⭐️")
            
        }
        return closestStation
    }

}

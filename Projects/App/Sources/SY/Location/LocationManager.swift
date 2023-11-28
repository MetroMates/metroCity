// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import CoreLocation
import Combine

struct Location {
    var crdntX: Double
    var crdntY: Double
}

/// 현재 위치의 위도 경도를 관리.
final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let clLocManager = CLLocationManager()
    private var locationString: String = "Fetching location..."
    
    private var userLocationInfo = Location(crdntX: 0.0, crdntY: 0.0)
    
    // 외부에서 사용.
    var userLocationPublisher = PassthroughSubject<Location, Never>()
    
    override init() {
        super.init()
        // CLLocationManager의 대리자를 self로 설정 -> LocationManager 클래스가 위치 서비스와 관련된 업데이트 및 이벤트를 처리한다는 것을 나타냄
        self.clLocManager.delegate = self
        
        // 포그라운드에 있는동안 위치 서비스를 사용할 수 있는 권한을 사용자에게 요청 (개인정보와 관련하여.. 앱 사용중일 때 위치 정보에 엑세스 할수 있다는 의미)
        // 해당 항목은 plist의 privacy 키값에 의해 제어됨
        // 장치에서 위치 서비스가 활성화되어 있는지 여부를 나타내는 부울 값을 반환합니다 locationServicesEnabled
        self.clLocManager.requestWhenInUseAuthorization()
        
        // 대리인(self)에게 위치 없데이트 전달을 시작함 -> delegate 채택으로 인하여 정의한 didUpdateLocations 대리자 메서드는 사용 가능한 새 위치 데이터가 있을 때마다 호출됩니다.
        // startUpdatingLocation : 유저 위치가져오기
        // Manager를 init할때는 가져올 필요없다. -> LoginManager를 사용하는 곳에서 필요에 의해 호출될 것. !!
        //        self.clLocManager.startUpdatingLocation()
    }
    
    /// 3키로 반경 이내 역중에 위경도 값 기준으로 가장 근사한 역 하나를 리턴해줌
    func calculateDistance(userLoc userLocation: Location,
                           statnLoc stationLocation: [StationLocation],
                           distance dis: Double) -> String {
        
        guard !stationLocation.isEmpty else { return "" }
        
        let userPoint = CLLocation(latitude: userLocation.crdntY, longitude: userLocation.crdntX)
        print("🍜 userPoint", userPoint)
        var calculatedStation: [StationLocation] = []
        
        for station in stationLocation {
            let stationPoint = CLLocation(latitude: station.crdntY, longitude: station.crdntX)
            
            let distance = stationPoint.distance(from: userPoint)
            
            if distance <= dis {
                calculatedStation.append(station)
            }
        }
        
//        var closestStation: StationLocation = .init(crdntX: <#T##Double#>, crdntY: <#T##Double#>, route: <#T##String#>, statnId: <#T##Int#>, statnNm: <#T##String#>)
        var rtnStationName: String = ""
        var minDifference: Double = Double.infinity
        
        print("🍜 caluStation \(calculatedStation)")
        for station in calculatedStation {
            let diffX = abs(station.crdntX - userLocation.crdntX)
            let diffY = abs(station.crdntY - userLocation.crdntY)

            let totalDifference = diffX + diffY

            if totalDifference < minDifference {
                minDifference = totalDifference
                rtnStationName = station.statnNm
            }
        }
        
        // StationLocation데이터의 이름 기준입니다.
        return rtnStationName
        
//        self.stationName = closestStation?.statnNm ?? ""
        
        /// stationInfo 컬렉션 기준으로 역이름 찾아내기 없으면 "" 리턴
//        let tempStaitonInfo = self.stationInfo?.filter { $0.statnNm.contains(self.stationName) }
//        self.findStationInfoNm = tempStaitonInfo?.first?.statnNm ?? ""
    }
}

// MARK: - CLLLocationManagerDelegate 메서드
extension LocationManager {
    /// 버튼을 누를 때마다 위치 업데이트를 하기 위해 함수로 따로 뺌!
    func fetchUserLocation() {
        self.clLocManager.requestLocation() // 한번만 가져오는 것.
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            // 위치를 가져오면 됨
            self.clLocManager.requestLocation()
            
        case .denied, .restricted:
            // 다시 권한 체크창 띄워야함.
            self.clLocManager.requestWhenInUseAuthorization()
            
        @unknown default:
            fatalError()
        }
    }
    
    /// delegate 관련 정의 함수
    /// 사용자의 업데이트된 위치를 나타내는 CLLocation 개체 배열을 중 마지막을 가져옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return } // 사용자 위치가 nil인지 아닌지 판단
        
        // 위도(latitude-37)와 경도(longitude-126) 추출하기
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        
//        latitude = 37.3366991
//        longitude = 126.7714132
        
        locationString = "🍜 위도: \(latitude), 경도: \(longitude)"
        print("⭐️\(locationString)")
        
        
        
        // 유저 위치값 추출해서 @Published로 만들어주기
        userLocationInfo.crdntY = latitude
        userLocationInfo.crdntX = longitude
        
        userLocationPublisher.send(userLocationInfo) // 데이터 발행
    }
    
    /// delegate 관련 정의 함수
    /// 위치 관리자가 사용자의 위치를 ​​가져오는 중 오류가 발생하면 이 메소드가 호출됩니다. -> 에러 처리 delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🍜 위치반환 실패 : \(error.localizedDescription)")
    }
    
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI
import CoreLocation
import Combine

struct Location {
    var crdntX: Double
    var crdntY: Double
}

/// 현재 위치의 위도 경도를 관리.
final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared: LocationManager = .init()
    
    var locationAuthStatus: CLAuthorizationStatus?
    @Published var isOpenSettingAlert: Bool = false
    
    // 외부에서 사용. -> 외부에서 사용시에 구독을 걸어둔 로직을 먼저 호출할 것이기 때문에 Passthrough로 사용. 처음부터 값을 방출할 필요가 없기 때문. 함수로 return
    private let userLocationPublisher = PassthroughSubject<Location, Never>()
    private let clLocManager = CLLocationManager()
    private var anyCancellable = Set<AnyCancellable>()
    
    override private init() {
        super.init()
        locationManagerSetting()
        subscribe()
    }
    
    deinit {
        anyCancellable.forEach { $0.cancel() }
    }
    
    func userLocPublisher() -> AnyPublisher<Location, Never> {
        return userLocationPublisher
            .share()
            .eraseToAnyPublisher()
    }
    
    /// 버튼을 누를 때마다 위치 업데이트를 하기 위해 함수로 따로 뺌!
    func fetchUserLocation() {
//        self.clLocManager.requestLocation()  // 한번만 가져오는 것. -> 엄청 느림.
        self.clLocManager.startUpdatingLocation()
    }
    
    /// 3키로 반경 이내 역중에 위경도 값 기준으로 가장 근사한 역 하나를 리턴해줌
    func calculateDistance(userLoc userLocation: Location,
                           statnLoc stationLocation: [StationLocation],
                           distance dis: Double) -> String {
        
        guard !stationLocation.isEmpty else { return "" }
        
        let userPoint = CLLocation(latitude: userLocation.crdntY, longitude: userLocation.crdntX)
        
        Log.trace("🍜 UserPoint \(userPoint)")
        
        var calculatedStation: [StationLocation] = []
        
        for station in stationLocation {
            let stationPoint = CLLocation(latitude: station.crdntY, longitude: station.crdntX)
            
            let distance = stationPoint.distance(from: userPoint)
            
            if distance <= dis {
                calculatedStation.append(station)
            }
        }
        
        var returnStationName: String = ""
        var minDifference: Double = Double.infinity
        
        for station in calculatedStation {
            let diffX = abs(station.crdntX - userLocation.crdntX)
            let diffY = abs(station.crdntY - userLocation.crdntY)

            let totalDifference = diffX + diffY

            if totalDifference < minDifference {
                minDifference = totalDifference
                returnStationName = station.statnNm
            }
        }
        
        // StationLocation데이터의 이름 기준입니다.
        return returnStationName

    }
    
    /// 위치 설정 창 열기
    func openLocationSetting() {
        if let bundleID = Bundle.main.bundleIdentifier,
           let settings = URL(string: UIApplication.openSettingsURLString + bundleID) {
            if UIApplication.shared.canOpenURL(settings) {
                UIApplication.shared.open(settings)
            }
        }
    }
    
}

// MARK: - CLLLocationManagerDelegate 메서드
extension LocationManager {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationAuthStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: // 결정됨.
            Log.trace("🦷 권한부여됨")
        case .notDetermined, .restricted: // 아직 미정
            self.clLocManager.requestWhenInUseAuthorization()
            
        case .denied: // 거부
            // 다시 권한 체크창 띄워야함.
            Log.trace("🦷 권한삭제됨")
            self.openLocationSetting()
            
        @unknown default:
            fatalError()
        }
        
        confirmAccuracyAuthorization()
    }
    
    /// delegate 관련 정의 함수
    /// 사용자의 업데이트된 위치를 나타내는 CLLocation 개체 배열을 중 마지막을 가져옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else {
            self.clLocManager.stopUpdatingLocation()
            return
        } // 사용자 위치가 nil인지 아닌지 판단
        // 위도(latitude-37)와 경도(longitude-126) 추출하기
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        Log.trace("⭐️🍜 위도: \(latitude), 경도: \(longitude)")
        
        self.locationSet(crdntY: latitude, crdntX: longitude)
        self.clLocManager.stopUpdatingLocation()
    }
    
    /// delegate 관련 정의 함수
    /// 위치 관리자가 사용자의 위치를 ​​가져오는 중 오류가 발생하면 이 메소드가 호출됩니다. -> 에러 처리 delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.warning("🍜 위치반환 실패 : \(error.localizedDescription)")
    }
}

// MARK: - Private Methods
extension LocationManager {
    private func subscribe() {
        $isOpenSettingAlert.sink { value in
            if value {
                self.openLocationSetting()
            }
        }
        .store(in: &anyCancellable)
    }
    
    /// 위도, 경도 받아와서 Location 객체를 만들어서
    private func locationSet(crdntY: Double, crdntX: Double) {
        let location: Location = .init(crdntX: crdntX, crdntY: crdntY)
        userLocationPublisher.send(location)
    }
    
    /// 초기 세팅
    private func locationManagerSetting() {
        // CLLocationManager의 대리자를 self로 설정 -> LocationManager 클래스가 위치 서비스와 관련된 업데이트 및 이벤트를 처리한다는 것을 나타냄
        self.clLocManager.delegate = self
        // 포그라운드에 있는동안 위치 서비스를 사용할 수 있는 권한을 사용자에게 요청 (개인정보와 관련하여.. 앱 사용중일 때 위치 정보에 엑세스 할수 있다는 의미)
        // 해당 항목은 plist의 privacy 키값에 의해 제어됨
        // 장치에서 위치 서비스가 활성화되어 있는지 여부를 나타내는 부울 값을 반환합니다 locationServicesEnabled
        self.clLocManager.requestWhenInUseAuthorization()
//        self.clLocManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func confirmAccuracyAuthorization() {
        switch self.clLocManager.accuracyAuthorization {
        case .fullAccuracy: // 정확한 위치 켬
            Log.trace("🦷 정확한 위치 켬")
        case .reducedAccuracy:  // 정확한 위치 끔.
            Log.trace("🦷 정확한 위치 끔.")
        @unknown default:
            fatalError()
        }
    }
}

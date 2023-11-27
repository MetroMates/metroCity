// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import Combine
import CoreLocation

final class LocationViewModel: ObservableObject {
    private let firestoreManager = FirebaseService.shared
    private let locationService = LocationManager()
    /// 3키로 이내로 계산 된 역값들
    private var calculatedStation: [StationLocation]?
    /// 유저 위치값
    @Published var userLocation: Location = Location(crdntX: 0.0, crdntY: 0.0)
    /// 패치된 StationLocation 정보
    @Published var stationLocation: [StationLocation] = []
    /// 유저와 가장 가까운 역정보
    @Published var targetStation: StationLocation?
    /// 패치된 StationInfo 정보
    @Published var stationInfo: [StationInfo]?
    /// 3키로 이내의 역이름
    @Published var stationName: String = ""
    /// stationInfo 기준으로 찾은 역 이름
    @Published var findStationInfoNm: String = ""
    
    private var anycancellable = Set<AnyCancellable>()
    
    init() {
//        self.subscribeLocation()
    }

//    func subscribeLocation() {
////        locationService.$userLocationInfo.sink { location in
////            self.userLocation = location
////        }
//        locationService.$userLocationInfo.assign(to: \.userLocation, on: self)
//        .store(in: &anycancellable)
//    }
    
    /// firebase의 stationLocation 컬렉션 패치해오기
    func fetchingData() {
        Task {
            do {
                let documents = try await firestoreManager.fetchStationLocations(collectionName: "StationLocation", type: StationLocation.self)
                print(documents)
                await MainActor.run {
                    self.stationLocation = documents
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// firebase의 StationInfo 컬렉션 패치해오기
    func fetchingStationInfo() {
        Task {
            do {
                let stationInfoData = try await firestoreManager.fetchStationLocations(collectionName: "StationInfo", type: StationInfo.self)
                print(stationInfoData)
                await MainActor.run {
                    self.stationInfo = stationInfoData
                }
            } catch {
                print("StationInfo fetch error: \(error.localizedDescription)")
            }
        }
    }
    
    /// 3키로 반경 이내 역중에 위경도 값 기준으로 가장 근사한 역 하나를 리턴해줌
    func calculateDistance() {
        guard !stationLocation.isEmpty else { return }
        
        let userPoint = CLLocation(latitude: self.userLocation.crdntY, longitude: self.userLocation.crdntX)
        
        self.calculatedStation = []
        for station in stationLocation {
            let stationPoint = CLLocation(latitude: station.crdntY, longitude: station.crdntX)
            
            let distance = stationPoint.distance(from: userPoint)
            
            if distance <= 3000 {
                self.calculatedStation?.append(station)
            }
        }
        
        var closestStation: StationLocation?
        var minDifference: Double = Double.infinity
        
        guard let calculatedStation = self.calculatedStation else { return }
        for station in calculatedStation {
            let diffX = abs(station.crdntX - userLocation.crdntX)
            let diffY = abs(station.crdntY - userLocation.crdntY)
            
            let totalDifference = diffX + diffY
            
            if totalDifference < minDifference {
                minDifference = totalDifference
                closestStation = station
            }
        }
        self.stationName = closestStation?.statnNm ?? ""
        
        /// stationInfo 컬렉션 기준으로 역이름 찾아내기 없으면 "" 리턴
        let tempStaitonInfo = self.stationInfo?.filter { $0.statnNm.contains(self.stationName) }
        self.findStationInfoNm = tempStaitonInfo?.first?.statnNm ?? ""
    }
    
    /// 유저 버튼 패치 버튼
    func locationButtonTapped() {
        locationService.fetchUserLocation()
    }
    
}

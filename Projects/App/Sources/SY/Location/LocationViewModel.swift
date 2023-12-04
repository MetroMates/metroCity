// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import Combine
import CoreLocation
import CoreData

final class LocationViewModel: ObservableObject {
    // MARK: - CoreData Test
    let coreDataManger = CoreDataManger.shared
    @Published var stationInfoCoreData: [StationInfoEntity] = []
    @Published var stationLocationCoreData: [StationLocationEntity] = []
    
    // 기존 코어데이터에 있던 StationInfo 데이터 패치
//    func getStationInfoEnities() -> [StationInfoEntity] {
//        let request = NSFetchRequest<StationInfoEntity>(entityName: "StationInfoEntity")
//
//        do {
//            stationInfoCoreData = try coreDataManger.context.fetch(request)
//        } catch let error {
//            print("StationInfo 데이터 패치 중 에러 발생! \(error), \(error.localizedDescription)")
//        }
//        print("👻 StationInfo 데이터 패치 완료 ")
//        return stationInfoCoreData
//    }
    
    /// CoreData에서 StationInfoEntity를 Fetch
    func getStationInfoEnities() {
//        self.stationInfoCoreData = coreDataManger.getEntities(entityName: "StationInfoEntity")
        self.stationInfoCoreData = coreDataManger.retrieve(type: StationInfoEntity.self)
    }
    
    func getStationLocationEntities() {
//        self.stationLocationCoreData = coreDataManger.getEntities(entityName: "StationLocationEntity")
        self.stationLocationCoreData = coreDataManger.retrieve(type: StationLocationEntity.self)
    }
    
    init() {
        // 뷰모델 초기화 때 패치해오기
        getStationInfoEnities()
        getStationLocationEntities()
//        self.subscribeLocation()
    }
    
    /// CoreData에 StationInfo 정보 추가하기
    func addStationInfoCoreData(subwayId: Int32, subwayNm: String, statnId: Int32, statnNm: String) {
//        let newStationInfo = StationInfoEntity(context: coreDataManger.context)
//        newStationInfo.id = UUID().uuidString
//        newStationInfo.statnId = statnId
//        newStationInfo.subwayId = subwayId
//        newStationInfo.subwayNm = subwayNm
//        newStationInfo.statnNm = statnNm
//        coreDataManger.save() //
    }
    
    /// CoreData에 StationLocation 정보 추가하기
    func addStationLocationCoreData(crdntX: Double, crdntY: Double, route: String, statnId: Int32, statnNm: String ) {
//        let newStationLocation = StationLocationEntity(context: coreDataManger.context)
//        newStationLocation.id = UUID().uuidString
//        newStationLocation.crdntX = crdntX
//        newStationLocation.crdntY = crdntY
//        newStationLocation.route = route
//        newStationLocation.statnId = statnId
//        newStationLocation.statnNm = statnNm
//        coreDataManger.save()
    }
    
    /// StationInfo가 코어데이터에 안 저장 되어있을 때 for문을 돌면서 코어데이터에 추가하기
    func checkAddStationInfo() {
        if self.stationInfoCoreData.isEmpty {
            guard let tempInfo = self.stationInfo else { return }
            for stationInfo in tempInfo {
                addStationInfoCoreData(subwayId: stationInfo.subwayId, subwayNm: stationInfo.subwayNm, statnId: stationInfo.statnId, statnNm: stationInfo.statnNm)
            }
        }
//        coreDataManger.save()
    }
    
    /// StationLocation이 코어데이터에 안 저장 되어있을 때 for문을 돌면서 코어데이터에 추가하기
    func checkAddStationLocation() {
        print("🥵🥵🥵 \(self.stationLocationCoreData.count)")
        if self.stationLocationCoreData.isEmpty {
            for location in stationLocation {
                addStationLocationCoreData(crdntX: location.crdntX, crdntY: location.crdntY, route: location.route, statnId: location.statnId, statnNm: location.statnNm)
            }
        }
//        coreDataManger.save()
    }
    
//    private let firestoreManager = FirebaseLocationManager.shared
//    private let locationService = LocationManager()
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

//    func subscribeLocation() {
////        locationService.$userLocationInfo.sink { location in
////            self.userLocation = location
////        }
//        locationService.$userLocationInfo.assign(to: \.userLocation, on: self)
//        .store(in: &anycancellable)
//    }
    
    // firebase의 stationLocation 컬렉션 패치해오기
//    func fetchingData() {
//        Task {
//            do {
//                let documents = try await firestoreManager.fetchStationLocations(collectionName: "StationLocation", type: StationLocation.self)
////                print(documents)
//                await MainActor.run {
//                    self.stationLocation = documents
//                }
//            } catch {
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//    }
    
    /// firebase의 StationInfo 컬렉션 패치해오기
//    func fetchingStationInfo() {
//        Task {
//            do {
//                let stationInfoData = try await firestoreManager.fetchStationLocations(collectionName: "StationInfo", type: StationInfo.self)
////                print(stationInfoData)
//                await MainActor.run {
//                    self.stationInfo = stationInfoData
//                }
//            } catch {
//                print("StationInfo fetch error: \(error.localizedDescription)")
//            }
//        }
//    }
    
    // 3키로 반경 이내 역중에 위경도 값 기준으로 가장 근사한 역 하나를 리턴해줌
//    func calculateDistance() {
//        guard !stationLocation.isEmpty else { return }
//
//        let userPoint = CLLocation(latitude: self.userLocation.crdntY, longitude: self.userLocation.crdntX)
//
//        self.calculatedStation = []
//        for station in stationLocation {
//            let stationPoint = CLLocation(latitude: station.crdntY, longitude: station.crdntX)
//
//            let distance = stationPoint.distance(from: userPoint)
//
//            if distance <= 3000 {
//                self.calculatedStation?.append(station)
//            }
//        }
//
//        var closestStation: StationLocation?
//        var minDifference: Double = Double.infinity
//
//        guard let calculatedStation = self.calculatedStation else { return }
//        for station in calculatedStation {
//            let diffX = abs(station.crdntX - userLocation.crdntX)
//            let diffY = abs(station.crdntY - userLocation.crdntY)
//
//            let totalDifference = diffX + diffY
//
//            if totalDifference < minDifference {
//                minDifference = totalDifference
//                closestStation = station
//            }
//        }
//        self.stationName = closestStation?.statnNm ?? ""
//
//        /// stationInfo 컬렉션 기준으로 역이름 찾아내기 없으면 "" 리턴
//        let tempStaitonInfo = self.stationInfo?.filter { $0.statnNm.contains(self.stationName) }
//        self.findStationInfoNm = tempStaitonInfo?.first?.statnNm ?? ""
//    }
//
//    /// 유저 버튼 패치 버튼
//    func locationButtonTapped() {
//        locationService.fetchUserLocation()
//    }
    
}

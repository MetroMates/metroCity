// Copyright © 2023 TDS. All rights reserved. 2023-11-28 화 오후 05:50 꿀꿀🐷

import SwiftUI
import Combine
import CoreData

final class StartVM: ObservableObject {
    @Published var selectTabIndex: Int = 0
    @Published var selectLineInfo: SubwayLineColor = .emptyData
    
    private let type: DataType
    private let dataManager: DataManager!
    //    private let stationInfoSubject = PassthroughSubject<[StationInfo], Never>()
    //    private let lineInfoSubject = PassthroughSubject<[SubwayLineColor], Never>()
    //    private let locInfoSubject = PassthroughSubject<[StationLocation], Never>()
    private let stationInfoSubject = CurrentValueSubject<[StationInfo], Never>([])
    private let lineInfoSubject = CurrentValueSubject<[SubwayLineColor], Never>([])
    private let locInfoSubject = CurrentValueSubject<[StationLocation], Never>([])
    private let localVer: Int
    private let userDefaultKEY: String
    
    init(type: DataType) {
        self.type = type
        debugPrint("1️⃣ \(type)")
        
        switch type {
        case .real:
            dataManager = RealDataManager()
            self.userDefaultKEY = "dataVersion"
        case .test:
            dataManager = TestDataManager()
            self.userDefaultKEY = "testDataVersion"
        }
        
        self.localVer = UserDefaults.standard.integer(forKey: userDefaultKEY)
        
        fetchDatas()
    }
    
    func dataPublisher() -> AnyPublisher<(Array<StationInfo>, Array<SubwayLineColor>, Array<StationLocation>), Never> {
        return stationInfoSubject.zip(lineInfoSubject, locInfoSubject)
            .share()
            .eraseToAnyPublisher()
    }
    
    private func fetchDatas() {
        dataManager.fetchDatas(statType: StationInfo.self,
                               subwayLineType: SubwayLineColor.self,
                               locationInfoType: StationLocation.self) { serverVer, statInfos, lineInfos, locInfos  in
            
            // 여기의 send부분이 해당 publisher에 구독, 즉 sink가 달리기도 전에 먼저 실행이 되게 되면
            // 추후 해당 publisher는 발행자로서의 기능을 상실하게 된다. 그래서 Passthrough가 아닌 CurrentValueSubject로 진행.
            self.stationInfoSubject.send(statInfos)
            self.lineInfoSubject.send(lineInfos)
            self.locInfoSubject.send(locInfos)
            
            // MARK: 테스트 다한후, .real로 변경
            if self.type == .real {
                if serverVer > self.localVer {
                    print("📝 setCoreData실행")
                    self.setCoreData(ver: serverVer, datas: statInfos, lineInfos, locInfos)
                }
            }
            
        }
    }
    
    private func deleteCoreData() {
        let coreDataManger = CoreDataManger.shared
        print("📝 deleteCoreData")
        _ = coreDataManger.deleteAll(type: StationInfoEntity.self)
        _ = coreDataManger.deleteAll(type: SubwayLineColorEntity.self)
        _ = coreDataManger.deleteAll(type: StationLocationEntity.self)
        
    }
    
    private func setCoreData(ver: Int, datas: [FireStoreCodable]...) {
        let coreDataManager = CoreDataManger.shared
        
        // 로컬버전이 0보다 클경우에는 무조건 이전 데이터를 삭제후 재입력 한다.
        if self.localVer > 0 {
            deleteCoreData()
        }
        
        DispatchQueue.global().async {
            let isResult = coreDataManager.create {
                // 백그라운드 스레드에서 CoreData에 값 넣어주는 작업. -> CoreData에서 자체적으로 UI관련되지 않은 작업들은 백그라운드에서 처리함.
                for dataGroup in datas {
                    for data in dataGroup {
                        switch data {
                        case let stationInfo as StationInfo:
                            // StationInfo에 대한 CoreData 로직
                            let newStationInfo = StationInfoEntity(context: coreDataManager.context)
//                            newStationInfo.id = "\(stationInfo.subwayId)-\(stationInfo.statnId)"
                            newStationInfo.statnId = stationInfo.statnId
                            newStationInfo.subwayId = stationInfo.subwayId
                            newStationInfo.subwayNm = stationInfo.subwayNm
                            newStationInfo.statnNm = stationInfo.statnNm
                            
                        case let subwayLineColor as SubwayLineColor:
                            // SubwayLineColor에 대한 CoreData 로직
                            let newSubwayLineColor = SubwayLineColorEntity(context: coreDataManager.context)
//                            newSubwayLineColor.id = "\(subwayLineColor.subwayId)"
                            newSubwayLineColor.subwayId = subwayLineColor.subwayId
                            newSubwayLineColor.subwayNm = subwayLineColor.subwayNm
                            newSubwayLineColor.lineColorHexCode = subwayLineColor.lineColorHexCode
                            
                        case let stationLocation as StationLocation:
                            let newStationLocation = StationLocationEntity(context: coreDataManager.context)
//                            newStationLocation.id = "\(stationLocation.statnId)"
                            newStationLocation.crdntX = stationLocation.crdntX
                            newStationLocation.crdntY = stationLocation.crdntY
                            newStationLocation.route = stationLocation.route
                            newStationLocation.statnId = stationLocation.statnId
                            newStationLocation.statnNm = stationLocation.statnNm
                            
                        default:
                            // 처리할 타입이 추가될 경우에 대한 로직
                            break
                        }
                    }
                }
            }
            
            // CoreData에 제대로 저장이 되었을 경우에만 로컬에 Ver 저장.
            if isResult {
                // UserDefaults에 데이터 버전 저장
                UserDefaults.standard.set(ver, forKey: self.userDefaultKEY)
            }
        }

    }
    
}

extension StartVM {
    enum DataType {
        case test, real
    }
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-28 화 오후 05:50 꿀꿀🐷

import SwiftUI
import Combine
import CoreData

final class StartVM: ObservableObject {
    @Published var selectTabIndex: Int = 0
    @Published var selectLineInfo: SubwayLineColor = .emptyData
    
    private let type: DataType
    private let dataManager: DataManager!
    private let stationInfoSubject = CurrentValueSubject<[StationInfo], Never>([])
    private let lineInfoSubject = CurrentValueSubject<[SubwayLineColor], Never>([])
    private let locInfoSubject = CurrentValueSubject<[StationLocation], Never>([])
    private let relateInfoSubject = CurrentValueSubject<[RelateStationInfo], Never>([])
    private let localVer: Int
    private let userDefaultKEY: String
    
    init(type: DataType) {
        Log.trace(type)
        
        self.type = type
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
    
    func dataPublisher() -> AnyPublisher<(Array<StationInfo>, 
                                          Array<SubwayLineColor>,
                                          Array<StationLocation>,
                                          Array<RelateStationInfo>), Never> {
        return stationInfoSubject.zip(lineInfoSubject, locInfoSubject, relateInfoSubject)
            .share()
            .eraseToAnyPublisher()
    }
    
    private func fetchDatas() {
        dataManager.fetchDatas(statType: StationInfo.self,
                               subwayLineType: SubwayLineColor.self,
                               locationInfoType: StationLocation.self,
                               relateType: RelateStationInfo.self) { serverVer, statInfos, lineInfos, locInfos, relateInfos  in
            
            // 여기의 send부분이 해당 publisher에 구독, 즉 sink가 달리기도 전에 먼저 실행이 되게 되면
            // 추후 해당 publisher는 발행자로서의 기능을 상실하게 된다. 그래서 Passthrough가 아닌 CurrentValueSubject로 진행.
            self.stationInfoSubject.send(statInfos)
            self.lineInfoSubject.send(lineInfos)
            self.locInfoSubject.send(locInfos)
            self.relateInfoSubject.send(relateInfos)
            
            Log.trace("🫣 StartVM Fetchs \(relateInfos)")
            
            // MARK: 테스트 다한후, .real로 변경
            if self.type == .real {
                if serverVer > self.localVer {
                    Log.trace("🍜🐷📝 CoreData SET")
                    self.setCoreData(ver: serverVer, datas: statInfos, lineInfos, locInfos, relateInfos)
                }
            }
            
        }
    }
    
    private func deleteCoreData() {
        let coreDataManger = CoreDataManger.shared
        Log.trace("📝 CoreData Delete")
        _ = coreDataManger.deleteAll(type: StationInfoEntity.self)
        _ = coreDataManger.deleteAll(type: SubwayLineColorEntity.self)
        _ = coreDataManger.deleteAll(type: StationLocationEntity.self)
        _ = coreDataManger.deleteAll(type: RelateStationInfoEntity.self)
    }
    
    private func setCoreData(ver: Int, datas: [FireStoreCodable]...) {
        let coreDataManager = CoreDataManger.shared
        
        DispatchQueue.global().async {
            // 로컬버전이 0보다 클경우에는 무조건 이전 데이터를 삭제후 재입력 한다.
            if self.localVer > 0 {
                self.deleteCoreData()
            }
            
            let newContext = coreDataManager.newContextForBackgroundThread()
            
            // 컨텍스트 큐에서 지정된 클로저의 Task를 비동기적으로 수행.
            newContext.performAndWait {
                let isResult = coreDataManager.create(contextValue: newContext) {
                    // 백그라운드 스레드에서 CoreData에 값 넣어주는 작업. -> CoreData에서 자체적으로 UI관련되지 않은 작업들은 백그라운드에서 처리함.
                    for dataGroup in datas {
                        for data in dataGroup {
                            switch data {
                            case let stationInfo as StationInfo:
                                // StationInfo에 대한 CoreData 로직
                                let newStationInfo = StationInfoEntity(context: newContext)
                                //                            newStationInfo.id = "\(stationInfo.subwayId)-\(stationInfo.statnId)"
                                
                                newStationInfo.statnId = stationInfo.statnId
                                newStationInfo.subwayId = stationInfo.subwayId
                                newStationInfo.subwayNm = stationInfo.subwayNm
                                newStationInfo.statnNm = stationInfo.statnNm
                                
                            case let subwayLineColor as SubwayLineColor:
                                // SubwayLineColor에 대한 CoreData 로직
                                let newSubwayLineColor = SubwayLineColorEntity(context: newContext)
                                //                            newSubwayLineColor.id = "\(subwayLineColor.subwayId)"
                                newSubwayLineColor.subwayId = subwayLineColor.subwayId
                                newSubwayLineColor.subwayNm = subwayLineColor.subwayNm
                                newSubwayLineColor.lineColorHexCode = subwayLineColor.lineColorHexCode
                                
                            case let stationLocation as StationLocation:
                                
                                let newStationLocation = StationLocationEntity(context: newContext)
                                //                            newStationLocation.id = "\(stationLocation.statnId)"
                                newStationLocation.crdntX = stationLocation.crdntX
                                newStationLocation.crdntY = stationLocation.crdntY
                                newStationLocation.route = stationLocation.route
                                newStationLocation.statnId = stationLocation.statnId
                                newStationLocation.statnNm = stationLocation.statnNm
                                
                            case let relateStation as RelateStationInfo: 
                                let newrelateStationInfo = RelateStationInfoEntity(context: newContext)
                                newrelateStationInfo.statnId = relateStation.statnId
                                newrelateStationInfo.statnNm = relateStation.statnNm
                                newrelateStationInfo.relateIds = relateStation.relateIds
                                newrelateStationInfo.relateNms = relateStation.relateNms
                                
                            default:
                                // 처리할 타입이 추가될 경우에 대한 로직
                                break
                            }
                        }
                    }
                }
                
                // CoreData에 제대로 저장이 되었을 경우에만 로컬에 Ver 저장.
                if isResult {
//                    UserDefaults에 데이터 버전 저장
                    UserDefaults.standard.set(ver, forKey: self.userDefaultKEY)
                }
                
            }
        }
    }
    
}

extension StartVM {
    enum DataType {
        case test, real
    }
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-28 화 오후 05:50 꿀꿀🐷

import CoreData
import SwiftUI

protocol DataManager {
    func fetchDatas<Station: FireStoreCodable,
                    SubwayLine: FireStoreCodable,
                    LocInfo: FireStoreCodable>(statType: Station.Type,
                                               subwayLineType: SubwayLine.Type,
                                               locationInfoType: LocInfo.Type,
                                               completion: @escaping (Int, [Station], [SubwayLine], [LocInfo]) -> Void)
}

final class RealDataManager: DataManager, FireStoreServiceDelegate {
    private let coreManage = CoreDataManger.shared

    private func getCoreData(completion: @escaping ([StationInfo], [SubwayLineColor], [StationLocation]) -> Void) {
        let stationEntity: [StationInfoEntity] = coreManage.getEntities(entityName: "StationInfoEntity")
        let stationInfo = stationEntity.flatMap { info -> [StationInfo] in
            var infos: [StationInfo] = []
            infos.append(.init(subwayId: info.subwayId, subwayNm: info.subwayNm, statnId: info.statnId, statnNm: info.statnNm))
            return infos
        }
        
        let lineEntity: [SubwayLineColorEntity] = coreManage.getEntities(entityName: "SubwayLineColorEntity")
        let lineInfo = lineEntity.flatMap { info -> [SubwayLineColor] in
            var infos: [SubwayLineColor] = []
            infos.append(.init(subwayId: info.subwayId, subwayNm: info.subwayNm, lineColorHexCode: info.lineColorHexCode))
            return infos
        }.sorted { $0.subwayId < $1.subwayId }
        
        let locationEntity: [StationLocationEntity] = coreManage.getEntities(entityName: "StationLocationEntity")
        let locInfo = locationEntity.flatMap { info -> [StationLocation] in
            var infos: [StationLocation] = []
            infos.append(.init(crdntX: info.crdntX, crdntY: info.crdntY, route: info.route, statnId: info.statnId, statnNm: info.statnNm))
            return infos
        }
        
        completion(stationInfo, lineInfo, locInfo)
        
    }
    
    func fetchDatas<Station, SubwayLine, LocInfo>(statType: Station.Type,
                                                  subwayLineType: SubwayLine.Type,
                                                  locationInfoType: LocInfo.Type,
                                                  completion: @escaping (Int, [Station], [SubwayLine], [LocInfo]) -> Void) where Station: FireStoreCodable, SubwayLine: FireStoreCodable, LocInfo: FireStoreCodable {

        Task {
            // 1. 버전 체크 firestore에서 VersionCheck 컬렉션 조회하여 ver 값 가져와서 UserDefault의 ver값과 비교하기.
            let serverVer: Int = 1 //  try await firestoreFetch(colName: "VersionCheck", docID: "version")
            let localVer: Int = UserDefaults.standard.integer(forKey: "dataVersion")
            
            // 2. localVer이 serverVer보다 낮을 시 Fetch.
            if serverVer > localVer {
                // 무조건 FireStore에서 Fetch. -> Fetch해온 정보를 CoreData에 저장.
                do {
                    let stationInfos = try await firestoreFetchAll(colName: "StationInfo", type: Station.self)
                    let subwayLineInfos = try await firestoreFetchAll(colName: "SubwayLineColor", type: SubwayLine.self)
                    let locInfos = try await firestoreFetchAll(colName: "StationLocation", type: LocInfo.self)
                    
                    // 해당 값을 받아서 화면에서는 처리하는 중이어야 한다. -> setCoreData는 그 후 실행.
                    completion(serverVer, stationInfos, subwayLineInfos, locInfos)
                    
                } catch {
                    print(error.localizedDescription)
                    completion(0, [], [], [])
                }
                
            } else {
                print("🫣CoreData로딩")
                // 무조건 coreData에서 Fetch.
                getCoreData { stationInfo, lineInfo, locInfo in
                    let statInfos = stationInfo as? [Station] ?? []
                    let lineInfos = lineInfo as? [SubwayLine] ?? []
                    let locInfos = locInfo as? [LocInfo] ?? []
                    
                    completion(serverVer, statInfos, lineInfos, locInfos)
                }
            }
        }
    }
    
}

final class TestDataManager: DataManager {
    private let coreManage = CoreDataManger.shared

    func fetchDatas<Station, SubwayLine, LocInfo>(statType: Station.Type,
                                                  subwayLineType: SubwayLine.Type,
                                                  locationInfoType: LocInfo.Type,
                                                  completion: @escaping (Int, [Station], [SubwayLine], [LocInfo]) -> Void) where Station: FireStoreCodable, SubwayLine: FireStoreCodable, LocInfo: FireStoreCodable {
        
        let serverVer: Int = 1
        let localVer: Int = UserDefaults.standard.integer(forKey: "testDataVersion")
        
        if serverVer > localVer {
            let stationInfos = Station.mockList
            let subwayLineInfos = SubwayLine.mockList
            let locInfos = LocInfo.mockList
            
            // Test는 -1
            completion(serverVer, stationInfos, subwayLineInfos, locInfos)
            
        } else {
            print("🫣CoreData로딩")
            // 무조건 coreData에서 Fetch.
            getCoreData { stationInfo, lineInfo, locInfo in
                let statInfos = stationInfo as? [Station] ?? []
                let lineInfos = lineInfo as? [SubwayLine] ?? []
                let locInfos = locInfo as? [LocInfo] ?? []
                
                completion(serverVer, statInfos, lineInfos, locInfos)
            }
            
        }

    }
    
    private func getCoreData(completion: @escaping ([StationInfo], [SubwayLineColor], [StationLocation]) -> Void) {
        let stationEntity: [StationInfoEntity] = coreManage.getEntities(entityName: "StationInfoEntity")
        let stationInfo = stationEntity.flatMap { info -> [StationInfo] in
            var infos: [StationInfo] = []
            infos.append(.init(subwayId: info.subwayId, subwayNm: info.subwayNm, statnId: info.statnId, statnNm: info.statnNm))
            return infos
        }
        
        let lineEntity: [SubwayLineColorEntity] = coreManage.getEntities(entityName: "SubwayLineColorEntity")
        let lineInfo = lineEntity.flatMap { info -> [SubwayLineColor] in
            var infos: [SubwayLineColor] = []
            infos.append(.init(subwayId: info.subwayId, subwayNm: info.subwayNm, lineColorHexCode: info.lineColorHexCode))
            return infos
        }.sorted { $0.subwayId < $1.subwayId }
        
        let locationEntity: [StationLocationEntity] = coreManage.getEntities(entityName: "StationLocationEntity")
        let locInfo = locationEntity.flatMap { info -> [StationLocation] in
            var infos: [StationLocation] = []
            infos.append(.init(crdntX: info.crdntX, crdntY: info.crdntY, route: info.route, statnId: info.statnId, statnNm: info.statnNm))
            return infos
        }
        
        completion(stationInfo, lineInfo, locInfo)
        
    }
    
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-28 화 오후 05:50 꿀꿀🐷

import CoreData
import SwiftUI

/// Version체크 Model
struct VersionCheck: FireStoreCodable {
    let beforeVer: Int
    let rm: String
    let updateDate: String
    let ver: Int
    
    static var mockList: [VersionCheck] = []
}

protocol DataManager {
    func fetchDatas<Station: FireStoreCodable,
                    SubwayLine: FireStoreCodable,
                    LocInfo: FireStoreCodable,
                    Relate: FireStoreCodable>(statType: Station.Type,
                                               subwayLineType: SubwayLine.Type,
                                               locationInfoType: LocInfo.Type,
                                              relateType: Relate.Type,
                                               completion: @escaping (Int, [Station], [SubwayLine], [LocInfo], [Relate]) -> Void)
}

final class RealDataManager: DataManager, FireStoreServiceDelegate {
    private let coreManager = CoreDataManger.shared

    func fetchDatas<Station, SubwayLine, LocInfo, Relate>(statType: Station.Type,
                                                          subwayLineType: SubwayLine.Type,
                                                          locationInfoType: LocInfo.Type,
                                                          relateType: Relate.Type,
                                                          completion: @escaping (Int, [Station], [SubwayLine], [LocInfo], [Relate]) -> Void) where Station: FireStoreCodable, SubwayLine: FireStoreCodable, LocInfo: FireStoreCodable, Relate: FireStoreCodable {
        
        Task {
            // 1. 버전 체크 firestore에서 VersionCheck 컬렉션 조회하여 ver 값 가져와서 UserDefault의 ver값과 비교하기.
            let versionData = try? await firestoreFetch(colName: "VersionCheck", docID: "version", type: VersionCheck.self)
            let serverVer: Int = versionData?.ver ?? 1
            let localVer: Int = UserDefaults.standard.integer(forKey: "dataVersion")
            
            Log.trace("📝🆚 server: \(serverVer) local: \(localVer)")
            
            // 2. localVer이 serverVer보다 낮을 시 Fetch.
            if serverVer > localVer {
                // 무조건 FireStore에서 Fetch. -> Fetch해온 정보를 CoreData에 저장.
                do {
                    let stationInfos: [Station] = try await firestoreFetchAll(colName: "StationInfo", type: Station.self)
                    let subwayLineInfos: [SubwayLine] = try await firestoreFetchAll(colName: "SubwayLineColor", type: SubwayLine.self)
                    let locInfos: [LocInfo] = try await firestoreFetchAll(colName: "StationLocation", type: LocInfo.self)
                    let relateInfos: [Relate] = try await firestoreFetchAll(colName: "RelateStationInfo", type: Relate.self)
                    
                    // 해당 값을 받아서 화면에서는 처리하는 중이어야 한다. -> setCoreData는 그 후 실행.
                    completion(serverVer, stationInfos, subwayLineInfos, locInfos, relateInfos)
                    
                } catch let error as NSError {
                    let fetchError = NSError(domain: "FireFetchAll", code: error.code)
                    Log.error(fetchError.localizedDescription)
                    
                    // 배열 3개중 하나라도 데이터가 안들어오면 앱실행이 불가능. 앱을 종료시키고 다시 실행하게 해야한다.
                    completion(serverVer, [], [], [], [])
                }
                
            } else {
                Log.trace("📝GetCoreData 로딩..")
                // 무조건 coreData에서 Fetch.
                getCoreData { stationInfo, lineInfo, locInfo, relateInfo in
                    let statInfos = stationInfo as? [Station] ?? []
                    let lineInfos = lineInfo as? [SubwayLine] ?? []
                    let locInfos = locInfo as? [LocInfo] ?? []
                    let relateInfos = relateInfo as? [Relate] ?? []
                    
                    completion(serverVer, statInfos, lineInfos, locInfos, relateInfos)
                }
            }
        }
    }
    
    private func getCoreData(completion: @escaping ([StationInfo], [SubwayLineColor], [StationLocation], [RelateStationInfo]) -> Void) {
        DispatchQueue.main.async { [self] in
            let stationEntity = coreManager.retrieve(type: StationInfoEntity.self)
            let stationInfo = stationEntity.flatMap { info -> [StationInfo] in
                var infos: [StationInfo] = []
                infos.append(.init(subwayId: info.subwayId, subwayNm: info.subwayNm ?? "", statnId: info.statnId, statnNm: info.statnNm ?? ""))
                return infos
            }
            
            let lineEntity = coreManager.retrieve(type: SubwayLineColorEntity.self)
            let lineInfo = lineEntity.flatMap { info -> [SubwayLineColor] in
                var infos: [SubwayLineColor] = []
                infos.append(.init(subwayId: info.subwayId, subwayNm: info.subwayNm ?? "", lineColorHexCode: info.lineColorHexCode ?? ""))
                return infos
            }.sorted { $0.subwayId < $1.subwayId }
            
            let locationEntity = coreManager.retrieve(type: StationLocationEntity.self)
            let locInfo = locationEntity.flatMap { info -> [StationLocation] in
                var infos: [StationLocation] = []
                infos.append(.init(crdntX: info.crdntX, crdntY: info.crdntY, route: info.route ?? "", statnId: info.statnId, statnNm: info.statnNm ?? ""))
                return infos
            }
            
            let relateEntity = coreManager.retrieve(type: RelateStationInfoEntity.self)
            let relateInfo = relateEntity.flatMap { info -> [RelateStationInfo] in
                var infos: [RelateStationInfo] = []
                let relate: RelateStationInfo = .init(statnId: info.statnId, statnNm: info.statnNm ?? "", relateIds: info.relateIds ?? [], relateNms: info.relateNms ?? [])
                
                infos.append(relate)
                
                return infos
            }
            
            completion(stationInfo, lineInfo, locInfo, relateInfo)
            
        }
    }
    
}

final class TestDataManager: DataManager {
    func fetchDatas<Station, SubwayLine, LocInfo, Relate>(statType: Station.Type,
                                                          subwayLineType: SubwayLine.Type,
                                                          locationInfoType: LocInfo.Type,
                                                          relateType: Relate.Type,
                                                          completion: @escaping (Int, [Station], [SubwayLine], [LocInfo], [Relate]) -> Void) where Station: FireStoreCodable, SubwayLine: FireStoreCodable, LocInfo: FireStoreCodable, Relate: FireStoreCodable {
        
        let stationInfos = Station.mockList
        let subwayLineInfos = SubwayLine.mockList
        let locInfos = LocInfo.mockList
        let relateInfos = Relate.mockList
        
        completion(-1, stationInfos, subwayLineInfos, locInfos, relateInfos)
        
    }
    
}

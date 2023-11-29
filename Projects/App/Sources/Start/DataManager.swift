// Copyright © 2023 TDS. All rights reserved. 2023-11-28 화 오후 05:50 꿀꿀🐷

import Foundation

protocol DataManager {
    func fetchDatas<Station: FireStoreCodable,
                    SubwayLine: FireStoreCodable,
                    LocInfo: FireStoreCodable>(statType: Station.Type,
                                               subwayLineType: SubwayLine.Type,
                                               locationInfoType: LocInfo.Type,
                                               completion: @escaping ([Station], [SubwayLine], [LocInfo]) -> Void)
}

final class RealDataManager: DataManager, FireStoreServiceDelegate {
    let coreManage = CoreDataManger.shared
    
    func fetchDatas<Station, SubwayLine, LocInfo>(statType: Station.Type,
                                                  subwayLineType: SubwayLine.Type,
                                                  locationInfoType: LocInfo.Type,
                                                  completion: @escaping ([Station], [SubwayLine], [LocInfo]) -> Void) where Station: FireStoreCodable, SubwayLine: FireStoreCodable, LocInfo: FireStoreCodable {

        Task {
            // 1. 버전 체크 firestore에서 VersionCheck 컬렉션 조회하여 ver 값 가져와서 UserDefault의 ver값과 비교하기.
            let serverVer: Int = 1 //  try await firestoreFetch(colName: "VersionCheck", docID: "version")
            let localVer: Int = 0 // UserDefaults.standard.integer(forKey: "version")
            
            // 2. localVer이 serverVer보다 낮을 시 Fetch.
            if serverVer > localVer {
                // 무조건 FireStore에서 Fetch. -> Fetch해온 정보를 CoreData에 저장.
                do {
                    let stationInfos = try await firestoreFetchAll(colName: "StationInfo", type: Station.self)
                    let subwayLineInfos = try await firestoreFetchAll(colName: "SubwayLineColor", type: SubwayLine.self)
                    let locInfos = try await firestoreFetchAll(colName: "StationLocation", type: LocInfo.self)
                    
                    completion(stationInfos, subwayLineInfos, locInfos)
                    
                    // UserDefault -> 1이라는 숫자가
                    
                } catch {
                    print(error.localizedDescription)
                    completion([], [], [])
                }
                
            } else {
                // 무조건 coreData에서 Fetch.
                
                
            }
            
        }
        
    }
    
    private func setCoreData() {
        // 백그라운드 스레드에서 CoreData에 값 넣어주는 작업.
        DispatchQueue.global().async {
            
        }
    }
    
    
}

final class TestDataManager: DataManager {
    func fetchDatas<Station, SubwayLine, LocInfo>(statType: Station.Type,
                                                  subwayLineType: SubwayLine.Type,
                                                  locationInfoType: LocInfo.Type,
                                                  completion: @escaping ([Station], [SubwayLine], [LocInfo]) -> Void) where Station: FireStoreCodable, SubwayLine: FireStoreCodable, LocInfo: FireStoreCodable {
        
        let stationInfos = Station.mockList
        let subwayLineInfos = SubwayLine.mockList
        let locInfos = LocInfo.mockList

        completion(stationInfos, subwayLineInfos, locInfos)
        
    }
}

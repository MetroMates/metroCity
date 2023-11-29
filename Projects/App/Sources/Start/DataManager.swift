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
    func fetchDatas<Station, SubwayLine, LocInfo>(statType: Station.Type,
                                                  subwayLineType: SubwayLine.Type,
                                                  locationInfoType: LocInfo.Type,
                                                  completion: @escaping ([Station], [SubwayLine], [LocInfo]) -> Void) where Station: FireStoreCodable, SubwayLine: FireStoreCodable, LocInfo: FireStoreCodable {

        Task {
            do {
                let stationInfos = try await firestoreFetchAll(colName: "StationInfo", type: Station.self)
                let subwayLineInfos = try await firestoreFetchAll(colName: "SubwayLineColor", type: SubwayLine.self)
                let locInfos = try await firestoreFetchAll(colName: "StationLocation", type: LocInfo.self)
                
//                print("👍🏻", subwayLineInfos)
                completion(stationInfos, subwayLineInfos, locInfos)
            } catch {
                print(error.localizedDescription)
                completion([], [], [])
            }
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

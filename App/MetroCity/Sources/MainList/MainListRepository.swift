// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import Foundation

// 네트워크 통신을 하여 json으로 가져온 데이터를 디코딩까지 하고 객체로 반환해주는 곳.
final class MainListRepository: SubwayRepositoryFetch {
    
    private let userNetworkStore = TrainAPIConnect(key: .train) // 통신 -> DataStore
//    private let userDBStore = UserDBStore() // 로컬
    
    // 여기서는 MainListModel의 데이터를 반환해주는 비즈니스 로직 작성.
    // MainListModel은 SubwayModelIdentifier를 채택하고 있음.
    func subwaysFetch<Content>(modelType: Content.Type) async -> [Content] where Content: SubwayModelIdentifier {
        
        let datas = await userNetworkStore.load(type: Arrived.self,
                                                urlAddress: .trainArrive,
                                                station: "서울")
        
        var mainLists: [MainListModel] = []
        
        if let datas {
            let arrivedDatas = datas.realtimeArrivalList
            
            for item in arrivedDatas {
                mainLists.append(.init(statnID: item.statnID,
                                       statnNm: item.statnNm,
                                       subwayID: item.subwayID,
                                       updnLine: item.updnLine,
                                       barvlDt: item.barvlDt))
            }
            
        }
        
        return mainLists as? [Content] ?? []
    }
    
    func getfavoriteList() {
        
    }
    
}

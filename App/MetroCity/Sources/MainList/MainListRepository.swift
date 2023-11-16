// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import Foundation

// 네트워크 통신을 하여 json으로 가져온 데이터를 디코딩까지 하고 객체로 반환해주는 곳.
final class MainListRepository: SubwayRepositoryFetch {
//    private let networkStore = APIService(delegate: TrainAPIService(key: .train))
    
    private weak var userNetworkStore: APIServiceDelegate?
    // 로컬 서버 -> 추후 타입 교체 (약한참조, 프로토콜)
    private var localStore: String
    
    init(networkStore: APIServiceDelegate? = nil,
         localStore: String = "") {
        self.userNetworkStore = networkStore
        self.localStore = localStore
    }
        
    // 여기서는 MainListModel의 데이터를 반환해주는 비즈니스 로직 작성.
    // MainListModel은 SubwayModelIdentifier를 채택하고 있음.
    func subwaysFetch<Content>(modelType: Content.Type) async -> [Content] where Content: SubwayModelIdentifier {
        // TODO:
        // 로컬 저장소에 저장되어있는 데이터가 있는지 비교 후
        // 서버에서 통신받아서 가져오기로 한다.
        
        if !localStore.isEmpty {
            return []
            
        } else {
            guard let userNetworkStore else { return [] }
            
            let api = Bundle.main.object(forInfoDictionaryKey: APIKEY.subway.rawValue)
            userNetworkStore.apikey = api as? String ?? ""
            
            let urlString = self.makeSubwayURL(apikey: userNetworkStore.apikey ?? "",
                                               urlAddress: .subwayArrive,
                                               station: "")
            
            userNetworkStore.urlString = urlString
            
            let datas = await userNetworkStore.workInUrlSession(type: Arrived.self)
            
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
    }
    
    // MARK: - Private Methods
    /// URL 반환 함수
    private func makeSubwayURL(apikey: String,
                               urlAddress: URLAddress,
                               station: String = "",
                               startIdx: String = "0",
                               endIdx: String = "5") -> String {
        var urlString: String = ""
        
        if station.isEmpty {
            urlString = "http://swopenAPI.seoul.go.kr/api/subway/\(apikey)/json/\(urlAddress.rawValue)/ALL"
        } else {
            urlString = "http://swopenAPI.seoul.go.kr/api/subway/\(apikey)/json/\(urlAddress.rawValue)/\(startIdx)/\(endIdx)/\(station)"
        }
        
        return urlString
        
    }
    
}

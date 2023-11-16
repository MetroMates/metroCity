// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import Foundation

// 네트워크 통신을 하여 json으로 가져온 데이터를 디코딩까지 하고 객체로 반환해주는 곳.
final class MainListRepository: SubwayRepositoryFetch {
    // 약한참조를 걸었더니 init메서드에서 값이 할당이 안된다..?? -> 풀리지않은 의문. 아래 GPT결론.
    /*---------- GPT --------------------------------------------------------------------------------------------------------------------------
         '약함'은 참조가 강하지 않음을 의미합니다. 가리키는 개체의 할당이 취소되는 것을 막지는 않습니다.
         APIServiceDelegate에 대한 다른 강력한 참조가 없는 경우 APIServiceDelegate 할당이 취소되면 userNetworkStore는 nil이 됩니다.
         userNetworkStore는 선택사항이므로 YourClass를 초기화할 때 networkStore에 값이 제공되지 않으면 nil이 될 수 있습니다.
        나의 결론: 약한참조는 해당 인스턴스가 사용될때 그때 할당이 되는데 subwaysFetch 메서드에서 해당 인스턴스를 사용하는게 아닌 옵셔널 바인딩을 먼저했기 때문에 그때는 사용하기 전이라
                 nil로 나오는 것일 듯하다.
     ------------------------------------------------------------------------------------------------------------------------------------------ */
    
    private let userNetworkStore: APIServiceDelegate?
    // 로컬 서버 -> 추후 타입 교체 (약한참조, 프로토콜)
    private let localStore: String
    
    init(networkStore: APIServiceDelegate?, localStore: String = "") {
        self.userNetworkStore = networkStore
        self.localStore = localStore
    }
        
    // 여기서는 MainListModel의 데이터를 반환해주는 비즈니스 로직 작성.
    // MainListModel은 SubwayModelIdentifier를 채택하고 있음.
    func subwaysFetch<Content>(modelType: Content.Type, station: String) async -> [Content] where Content: SubwayModelIdentifier {
        // TODO:
        // 로컬 저장소에 저장되어있는 데이터가 있는지 비교 후
        // 서버에서 통신받아서 가져오기로 한다.
        
        if !localStore.isEmpty {
            return []
            
        } else {
            guard let userNetworkStore
            else {
                debugPrint("userNetworkStore 없음")
                return []
            }
            
            let api = Bundle.main.object(forInfoDictionaryKey: APIKEY.subway.rawValue)
            userNetworkStore.apikey = api as? String ?? ""
            
            let urlString = self.makeSubwayURL(apikey: userNetworkStore.apikey ?? "",
                                               urlAddress: .subwayArrive,
                                               station: station)
            
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

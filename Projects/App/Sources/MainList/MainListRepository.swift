// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import Foundation
import Combine

// 네트워크 통신을 하여 json으로 가져온 데이터를 디코딩까지 하고 객체로 반환해주는 곳.
final class MainListRepository: SubwayRepositoryFetch {
    func fetchAllFBdatas<Content>(colType: String, type: Content.Type) async -> [Content] where Content : FireStoreCodable {
        return []
    }
    
    
    // 약한참조를 걸었더니 init메서드에서 값이 할당이 안된다..?? -> 풀리지않은 의문. 아래 GPT결론.
    /*---------- GPT --------------------------------------------------------------------------------------------------------------------------
         '약함'은 참조가 강하지 않음을 의미합니다. 가리키는 개체의 할당이 취소되는 것을 막지는 않습니다.
         APIServiceDelegate에 대한 다른 강력한 참조가 없는 경우 APIServiceDelegate 할당이 취소되면 userNetworkStore는 nil이 됩니다.
         userNetworkStore는 선택사항이므로 YourClass를 초기화할 때 networkStore에 값이 제공되지 않으면 nil이 될 수 있습니다.
        나의 결론: 약한참조는 해당 인스턴스가 사용될때 그때 할당이 되는데 subwaysFetch 메서드에서 해당 인스턴스를 사용하는게 아닌 옵셔널 바인딩을 먼저했기 때문에 그때는 사용하기 전이라
                 nil로 나오는 것일 듯하다.
     ------------------------------------------------------------------------------------------------------------------------------------------ */
    
    // 네트워크 통신
    private let userNetworkStore: APIServiceDelegate?
    
    // 로컬 서버 -> 추후 타입 교체 (약한참조, 프로토콜) CoreData
    private let localStore: String
    
    init(networkStore: APIServiceDelegate?, localStore: String = "") {
        self.userNetworkStore = networkStore
        self.localStore = localStore
    }
    
    func receivePublisher<Content>(type: Content.Type, urlType: URLAddress, whereData: String) -> AnyPublisher<Content, Error> where Content: SubwayModel2Server {
        // 로컬 저장소에 저장되어있는 데이터가 있는지 비교 후
        // 서버에서 통신받아서 가져오기로 한다.
        if !localStore.isEmpty {
            return Empty().setFailureType(to: Error.self).eraseToAnyPublisher()
            
        } else {
            guard let userNetworkStore
            else {
                debugPrint("userNetworkStore 없음")
                return Empty().setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            
            let api = Bundle.main.object(forInfoDictionaryKey: APIKEY.subway.rawValue)
            userNetworkStore.apikey = api as? String ?? ""
            
            let urlString = self.makeSubwayURL(apikey: userNetworkStore.apikey ?? "",
                                               urlAddress: urlType,
                                               station: whereData)
            
            userNetworkStore.urlString = urlString
            
            return Empty().setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    func fetchingData<Content>(type: Content.Type, colName: String) async -> [Content] where Content: FireStoreCodable {
        guard !colName.isEmpty else { return [] }
        
        // TODO: firestoreFetch 만들기 colName, docID, Content.Type -> Content?
//        let ver = try? await fires
        
        // TODO: if ver이 UserDefault가 가진 ver보다 크면 아래 로직 실행. 그렇지 않으면 coreData에서 가져오기.
        
        do {
            return try await firestoreFetchAll(colName: colName, type: Content.self)
        } catch {
            print("🍜Error: \(error.localizedDescription)")
        }
        return []
    }
    
}

extension MainListRepository {
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

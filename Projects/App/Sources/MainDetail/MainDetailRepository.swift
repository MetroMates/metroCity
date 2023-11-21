// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import Foundation

final class MainDetailRepository: SubwayRepositoryFetch {
    private let networkService: APIServiceDelegate?
    private let localService: String // -> 추후에 Service 타입으로 변경할 것.
    
    private let apikey = Bundle.main.object(forInfoDictionaryKey: APIKEY.subway.rawValue)
    
    init(networkService: APIServiceDelegate?, localService: String = "") {
        self.networkService = networkService
        self.localService = localService
    }
    
    func subwaysFetch<Content>(modelType: Content.Type,
                               urlType: URLAddress,
                               whereData: String) async -> [Content] where Content: SubwayModelIdentifier {
        guard let networkService else { return [] }
        
        networkService.apikey = self.apikey as? String ?? ""
        let urlString = self.makeSubwayURL(apikey: networkService.apikey ?? "",
                                           urlAddress: .subwayArrive,
                                           station: whereData)
        networkService.urlString = urlString
        
        var rtnDatas: [HosunInfo] = []
        
        let data = await networkService.workInUrlSession(type: Arrived.self)
//        print("👀", data)
        if let data {
            let arrivedDatas = data.realtimeArrivalList
            let subwayLines = arrivedDatas.first?.subwayList

            if let subwayLines {
//                print("subwayLines", subwayLines)
                let separatedArray = subwayLines.components(separatedBy: ",")
//                print("separatedArray", separatedArray)
                for item in separatedArray {
                    rtnDatas.append(.init(subwayID: item,
                                          subwayNm: SubwayLine(rawValue: item)?.subwayName ?? "",
                                          hosunColor: SubwayLine(rawValue: item)?.subwayColor ?? .black,
                                          lineColor: SubwayLine(rawValue: item)?.subwayColor ?? .black))
                }
                return rtnDatas as? [Content] ?? []
            }
            
        }
        return []
    }
    
    func subwayFetch<Content>(modelType: Content.Type,
                              urlType: URLAddress,
                              whereData: String) async -> Content? where Content: SubwayModel {
        guard let networkService else { return nil }
        
        networkService.apikey = self.apikey as? String ?? ""
        let urlString = self.makeSubwayURL(apikey: networkService.apikey ?? "",
                                           urlAddress: .subwayPosition,
                                           station: whereData)
        networkService.urlString = urlString
        
        return nil
    }

    /// URL 반환 함수
    private func makeSubwayURL(apikey: String,
                               urlAddress: URLAddress,
                               station: String = "",
                               startIdx: String = "1",
                               endIdx: String = "1") -> String {
        var urlString: String = ""
        
        if station.isEmpty {
            urlString = "http://swopenAPI.seoul.go.kr/api/subway/\(apikey)/json/\(urlAddress.rawValue)/ALL"
        } else {
            urlString = "http://swopenAPI.seoul.go.kr/api/subway/\(apikey)/json/\(urlAddress.rawValue)/\(startIdx)/\(endIdx)/\(station)"
        }
        
        return urlString
    }
    
}

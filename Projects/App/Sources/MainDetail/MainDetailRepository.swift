// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import Foundation
import Combine

final class MainDetailRepository: SubwayRepositoryFetch {

    private let networkService: APIServiceDelegate?
    private let localService: String // -> 추후에 Service 타입으로 변경할 것.
    private let apikey = Bundle.main.object(forInfoDictionaryKey: APIKEY.subway.rawValue)
    
    init(networkService: APIServiceDelegate?, localService: String = "") {
        self.networkService = networkService
        self.localService = localService
    }
    
    func receivePublisher<Content>(type: Content.Type,
                                   urlType: URLAddress,
                                   whereData: String) -> AnyPublisher<Content, Error> where Content: SubwayModel2Server {
        
        guard let networkService else { return Fail(error: StatusError.ERR100).eraseToAnyPublisher() }
        
        networkService.apikey = self.apikey as? String ?? ""
        let urlString = self.makeSubwayURL(apikey: networkService.apikey ?? "",
                                           urlAddress: .subwayArrive,
                                           whereData: whereData)
        networkService.urlString = urlString
        print("url \(networkService.urlString)")
        return networkService.request(type: Content.self)
        
    }
    
}

// MARK: - Private Functions
extension MainDetailRepository {
    /// URL 반환 함수
    private func makeSubwayURL(apikey: String,
                               urlAddress: URLAddress,
                               whereData: String = "",
                               startIdx: String = "1",
                               endIdx: String = "1") -> String {
        var urlString: String = ""
        
        if whereData.isEmpty {
            urlString = "http://swopenAPI.seoul.go.kr/api/subway/\(apikey)/json/\(urlAddress.rawValue)/ALL"
        } else {
            urlString = "http://swopenAPI.seoul.go.kr/api/subway/\(apikey)/json/\(urlAddress.rawValue)/\(startIdx)/\(endIdx)/\(whereData)"
        }
        
        return urlString
    }
}

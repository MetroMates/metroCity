// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import Foundation

final class MainDetailRepository: SubwayRepositoryFetch {
    private let networkService: SubwayAPIService?
    private let localService: String // -> 추후에 Service 타입으로 변경할 것.
    
    init(networkService: SubwayAPIService?, localService: String = "") {
        self.networkService = networkService
        self.localService = localService
    }
    
    func subwaysFetch<Content>(modelType: Content.Type, station: String) async -> [Content] where Content: SubwayModelIdentifier {
        return []
    }
}

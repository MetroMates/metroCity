// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 06:43 꿀꿀🐷

import Foundation
import Combine

protocol SubwayRepository: SubwayRepositoryFetch, SubwayRepositoryUD { }

protocol SubwayRepositoryFetch {
    func receivePublisher<Content>(type: Content.Type,
                                   urlType: URLAddress,
                                   whereData: String) -> AnyPublisher<Content, Error> where Content: SubwayModel2Server
    /// 서버에서 데이터 fetch. 배열로 받음.
//    func subwaysFetch<Content>(modelType: Content.Type,
//                               urlType: URLAddress,
//                               whereData: String) async -> [Content] where Content: SubwayModelIdentifier
//    /// 서버에서 데이터 fetch
//    func subwayFetch<Content>(modelType: Content.Type,
//                              urlType: URLAddress,
//                              whereData: String) async -> Content? where Content: SubwayModel
}

protocol SubwayRepositoryUpdate {
    func subwayUpdate()
}

protocol SubwayRepositoryDelete {
    func subwayDelete()
}

protocol SubwayRepositoryUD: SubwayRepositoryUpdate, SubwayRepositoryDelete { }

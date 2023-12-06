// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 06:43 꿀꿀🐷

import Foundation
import Combine
import FirebaseFirestore

protocol SubwayRepository: SubwayRepositoryFetch, SubwayRepositoryUD { }

protocol SubwayRepositoryFetch: FireStoreServiceDelegate {
    func receivePublisher<Content>(type: Content.Type,
                                   urlType: URLAddress,
                                   whereData: String) -> AnyPublisher<Content, Error> where Content: SubwayModel2Server

    func fetchingData<Content>(type: Content.Type, colName: String) async -> [Content] where Content: FireStoreCodable
}

extension SubwayRepositoryFetch {
    func fetchingData<Content>(type: Content.Type, colName: String) async -> [Content] where Content: FireStoreCodable {
        return []
    }
}

protocol SubwayRepositoryUpdate {
    func subwayUpdate()
}

protocol SubwayRepositoryDelete {
    func subwayDelete()
}

protocol SubwayRepositoryUD: SubwayRepositoryUpdate, SubwayRepositoryDelete { }

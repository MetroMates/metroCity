// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 06:43 꿀꿀🐷

import Foundation

protocol SubwayRepository: SubwayRepositoryFetch, SubwayRepositoryUD { }

protocol SubwayRepositoryFetch {
    /// 서버에서 데이터 fetch. 배열로 받음.
    func subwaysFetch<Content>(modelType: Content.Type,
                               urlType: URLAddress,
                               whereData: String) async -> [Content] where Content: SubwayModelIdentifier
    /// 서버에서 데이터 fetch
    func subwayFetch<Content>(modelType: Content.Type,
                              urlType: URLAddress,
                              whereData: String) async -> Content? where Content: SubwayModel
}

protocol SubwayRepositoryUpdate {
    func subwayUpdate()
}

protocol SubwayRepositoryDelete {
    func subwayDelete()
}

protocol SubwayRepositoryUD: SubwayRepositoryUpdate, SubwayRepositoryDelete { }

/// 기본 세팅.
extension SubwayRepositoryFetch {
    /// 기본 세팅을 위한 함수
    func subwaysFetch<Content>(modelType: Content.Type,
                               urlType: URLAddress,
                               whereData: String) async -> [Content] where Content: SubwayModelIdentifier {
        return []
    }
    /// 기본 세팅을 위한 함수
    func subwayFetch<Content>(modelType: Content.Type,
                              urlType: URLAddress,
                              whereData: String) async -> Content? where Content: SubwayModel {
        return nil
    }
}

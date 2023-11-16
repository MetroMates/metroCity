// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 06:43 꿀꿀🐷

import Foundation

protocol SubwayRepository: SubwayRepositoryFetch, SubwayRepositoryUD { }

protocol SubwayRepositoryFetch {
    /// 서버에서 데이터 fetch
    func subwaysFetch<Content>(modelType: Content.Type) async -> [Content] where Content: SubwayModelIdentifier
}

protocol SubwayRepositoryUpdate {
    func subwayUpdate()
}

protocol SubwayRepositoryDelete {
    func subwayDelete()
}

protocol SubwayRepositoryUD: SubwayRepositoryUpdate, SubwayRepositoryDelete { }

// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// APIService 프로토콜
/// apikey, urlString값을 각각 넣어준 후
/// workInURLSession에 동작할 통신동작의 로직을 구현해준다.
protocol APIServiceDelegate: AnyObject {
    /// ApiKey
    var apikey: String? { get set }
    /// 통신용 URL
    var urlString: String? { get set }

    func request<Content>(type: Content.Type) -> AnyPublisher<Content, Error> where Content: SubwayModel2Server
    
}

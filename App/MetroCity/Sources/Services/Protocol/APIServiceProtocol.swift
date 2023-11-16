// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import Foundation

protocol APIServiceDelegate: AnyObject {
    /// ApiKey
    var apikey: String? { get set }
    /// 통신용 URL
    var urlString: String? { get set }    
    /// 세션에서 fetch후 작업할 로직
    func workInUrlSession<Content>(type: Content.Type) async -> Content? where Content: SubwayModeling
}

// extension APIServiceDelegate {
//    func getURL(url: String) -> String {
//        return url
//    }
// }

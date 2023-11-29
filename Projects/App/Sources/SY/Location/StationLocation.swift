// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation

struct StationLocation: Decodable {
    let id = UUID().uuidString
    /// 경도
    let crdntX: Double
    /// 위도
    let crdntY: Double
    /// 지하철 호선
    let route: String
    /// 지하철 역 코드명
    let statnId: Int32
    /// 지하철 역명
    let statnNm: String
}

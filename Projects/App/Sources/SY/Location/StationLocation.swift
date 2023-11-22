// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation

struct StationLocation {
    
    /// 경도
    let crdnX: String
    /// 위도
    let crndY: String
    /// 지하철 호선
    let route: String
    /// 지하철 역 코드명
    let statnId: String
    /// 지하철 역명
    let statNm: String
    
}

/// 사용예제
let testStation = StationLocation(crdnX: "126.794461", crndY: "37.658239", route: "경의중앙선", statnId: "1273", statNm: "백마")

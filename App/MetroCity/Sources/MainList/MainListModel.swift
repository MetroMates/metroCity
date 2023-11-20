// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 12:30 린다꿀꿀이🐷

import SwiftUI

/// 모든 호선별 역정보 파이어베이스에서 가져올 것.
///
/// 역정보 (전체)
struct StationInfo: SubwayModelIdentifier {
    let id = UUID().uuidString
    let subwayId: String
    let subwayNm: String
    /// 역 ID
    let statnId: String
    /// 역명
    let statnNm: String
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

/*
    필요한 DTO
    1. 해당호선에 대한 모든 역정보
       statnID, statnNM
    2. 해당호선 색상, 전반적인 UI의 색상

 */

struct MainDetailModel {
    let stationColor: Color
    let stationInfos: [StationInfo]
}

struct StationInfo: SubwayModelIdentifier {
    let id: String = UUID().uuidString
    /// 현재 지하철역ID
    let statnId: String
    /// 현재 지하철역명
    let statnNm: String
    /// 이전 지하철역ID
    /// 이전 지하철역명
    /// 다음 지하철역ID
    /// 다음 지하철역명
    /// 상하행선 구분 (0: 상행/내선, 1: 하행/외선)
    /// 도착지방면 (성수행(목적지역) - 구로디지털단지방면(다음역))
    /// 도착코드  (0:진입, 1:도착, 2:출발, 3:전역출발, 4:전역진입, 5:전역도착, 99:운행중)
    /// 열차종류(급행, ITX, 일반, 특급)
    
}

extension MainDetailModel {
    static var emptyData: Self {
        return .init(stationColor: .primary,
                     stationInfos: [])
    }
}

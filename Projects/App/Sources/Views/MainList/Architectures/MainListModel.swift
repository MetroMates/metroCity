// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 12:30 린다꿀꿀이🐷

import SwiftUI
import CoreData

/// 모든 호선별 역정보 파이어베이스에서 가져올 것.
///
/// 역정보 (전체) -> 엑셀양식을 다운받아서 FireStore에 올릴 예정. -> 추후 Firestore에서 내려바당서 사용.
struct StationInfo: FireStoreCodable, SubwayModelIdentifier {
    let id = UUID().uuidString
    let subwayId: Int32
    let subwayNm: String
    /// 역 ID
    let statnId: Int32
    /// 역명
    let statnNm: String
    
    init(subwayId: Int32, subwayNm: String, statnId: Int32, statnNm: String) {
        self.subwayId = subwayId
        self.subwayNm = subwayNm
        self.statnId = statnId
        self.statnNm = statnNm
    }
}

extension StationInfo {
    static var list: [Self] = []
    
    // 이 데이터를 가지고 예를 들면 statnNm이 신길온천인 모든 호선을 찾아서 
    static var mockList: [Self] = [
        .init(subwayId: 1001, subwayNm: "1호선", statnId: 1001000141, statnNm: "구로"),
        .init(subwayId: 1001, subwayNm: "1호선", statnId: 1001080149, statnNm: "금정"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000443, statnNm: "금정"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000444, statnNm: "산본"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000445, statnNm: "수리산"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000446, statnNm: "대야미"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000447, statnNm: "반월"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000448, statnNm: "상록수"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000449, statnNm: "한대앞"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000450, statnNm: "중앙"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000451, statnNm: "고잔"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000452, statnNm: "초지"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000453, statnNm: "안산"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000454, statnNm: "신길온천"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000455, statnNm: "정왕"),
        .init(subwayId: 1005, subwayNm: "5호선", statnId: 1005000512, statnNm: "김포공항"),
        .init(subwayId: 1007, subwayNm: "7호선", statnId: 1007000727, statnNm: "건대입구"),
        .init(subwayId: 1075, subwayNm: "수인분당선", statnId: 1075075256, statnNm: "신길온천"),
        .init(subwayId: 1075, subwayNm: "수인분당선", statnId: 1075075257, statnNm: "정왕"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000425, statnNm: "회현"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000426, statnNm: "서울"),
        .init(subwayId: 1004, subwayNm: "4호선", statnId: 1004000427, statnNm: "숙대입구")
    ]
    
}

/// 연관 역정보
struct RelateStationInfo: FireStoreCodable {
    let id = UUID().uuidString
    let statnId: Int32
    let statnNm: String
    let relateIds: [Int32]
    let relateNms: [String]
}

extension RelateStationInfo {
    static var mockList: [Self] = [
        .init(statnId: 1001000141, statnNm: "구로", relateIds: [1001080142, 1001000142], relateNms: ["가산디지털단지", "구일"]),
//        .init(statnId: 1001000141, statnNm: "구로", relateIds: [1001080142, 1001000142], relateNms: ["가산디지털단지", "구일"])
    ]
    static var emptyData: Self = .init(statnId: 0,
                                       statnNm: "",
                                       relateIds: [],
                                       relateNms: [])
}

/// MainList를 구성하는 SubwayLine 모델
/// FireStore에서 fetch해온다.
struct SubwayLineColor: FireStoreCodable, Identifiable {
    let id: String = UUID().uuidString
    /// 호선 정보 1002
    let subwayId: Int32
    /// 호선 이름
    let subwayNm: String
    /// 호선별 색상정보
    let lineColorHexCode: String
    
    init(subwayId: Int32, subwayNm: String, lineColorHexCode: String) {
//        self.id = UUID().uuidString // -> 여기서 주면 fetch가 안됨. Firebase에서 id를 가져오는 과정에서의 충돌.
        self.subwayId = subwayId
        self.subwayNm = subwayNm
        self.lineColorHexCode = lineColorHexCode
    }
}

extension SubwayLineColor {
    var lineColor: Color {
        return Color(hex: lineColorHexCode)
    }
    
    static var mockList: [Self] = [.init(subwayId: 1001, subwayNm: "1호선", lineColorHexCode: "#263B96"),
                                   .init(subwayId: 1002, subwayNm: "2호선", lineColorHexCode: "#3CB44A"),
                                   .init(subwayId: 1003, subwayNm: "3호선", lineColorHexCode: "#F06F01"),
                                   .init(subwayId: 1004, subwayNm: "4호선", lineColorHexCode: "#2C9EDE"),
                                   .init(subwayId: 1005, subwayNm: "5호선", lineColorHexCode: "#8836DF"),
                                   .init(subwayId: 1006, subwayNm: "6호선", lineColorHexCode: "#B5500A"),
                                   .init(subwayId: 1075, subwayNm: "수인분당선", lineColorHexCode: "#EBA900")]
    
    static var emptyData: Self {
        .init(subwayId: 0,
              subwayNm: "",
              lineColorHexCode: "")
    }
}

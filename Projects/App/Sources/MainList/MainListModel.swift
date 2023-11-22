// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 12:30 린다꿀꿀이🐷

import SwiftUI

/// 모든 호선별 역정보 파이어베이스에서 가져올 것.
///
/// 역정보 (전체) -> 엑셀양식을 다운받아서 FireStore에 올릴 예정. -> 추후 Firestore에서 내려바당서 사용.
struct StationInfo: FireStoreCodable, SubwayModelIdentifier {
    let id: String
    let subwayId: Int
    let subwayNm: String
    /// 역 ID
    let statnId: Int
    /// 역명
    let statnNm: String
    
    init(subwayId: Int, subwayNm: String, statnId: Int, statnNm: String) {
        self.id = UUID().uuidString
        self.subwayId = subwayId
        self.subwayNm = subwayNm
        self.statnId = statnId
        self.statnNm = statnNm
    }
}

extension StationInfo {
    static var list: [Self] = []
    
    // 이 데이터를 가지고 예를 들면 statnNm이 신길온천인 모든 호선을 찾아서 
    static var testList: [Self] = [
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
        .init(subwayId: 1075, subwayNm: "수인분당선", statnId: 1075075257, statnNm: "정왕")
    ]
    
}

/// MainList를 구성하는 SubwayLine 모델
/// FireStore에서 fetch해온다.
struct SubwayLineColor: FireStoreCodable, Identifiable {
    let id: String
    let subwayId: Int
    let subwayNm: String
    let lineColorHexCode: String
    
    init(subwayId: Int, subwayNm: String, lineColorHexCode: String) {
        self.id = UUID().uuidString
        self.subwayId = subwayId
        self.subwayNm = subwayNm
        self.lineColorHexCode = lineColorHexCode
    }
}

extension SubwayLineColor {
    var lineColor: Color {
        return Color(hex: lineColorHexCode)
    }
}

/// Test용 데이터 객체
struct TestSubwayLineColor: FireStoreCodable, Identifiable {
    let id: String
    let subwayId: Int
    let subwayNm: String
    let lineColorHexCode: String
    
    init(subwayId: Int, subwayNm: String, lineColorHexCode: String) {
        self.id = UUID().uuidString
        self.subwayId = subwayId
        self.subwayNm = subwayNm
        self.lineColorHexCode = lineColorHexCode
    }
}

extension TestSubwayLineColor {
    var lineColor: Color {
        return Color(hex: lineColorHexCode)
    }
}

extension TestSubwayLineColor {
    static var tempData: [Self] {
        return [.init(subwayId: 1001, subwayNm: "1호선", lineColorHexCode: "#263B96"),
                .init(subwayId: 1002, subwayNm: "2호선", lineColorHexCode: "#3CB44A"),
                .init(subwayId: 1003, subwayNm: "3호선", lineColorHexCode: "#F06F01"),
                .init(subwayId: 1004, subwayNm: "4호선", lineColorHexCode: "#2C9EDE"),
                .init(subwayId: 1005, subwayNm: "5호선", lineColorHexCode: "#8836DF"),
                .init(subwayId: 1006, subwayNm: "6호선", lineColorHexCode: "#B5500A"),
                .init(subwayId: 1075, subwayNm: "수인분당선", lineColorHexCode: "#EBA900")]
    }
    
    static var emptyData: Self {
        .init(subwayId: 0,
              subwayNm: "",
              lineColorHexCode: "")
    }
}

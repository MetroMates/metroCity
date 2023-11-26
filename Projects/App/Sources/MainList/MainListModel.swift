// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 12:30 린다꿀꿀이🐷

import SwiftUI

/// 모든 호선별 역정보 파이어베이스에서 가져올 것.
///
/// 역정보 (전체) -> 엑셀양식을 다운받아서 FireStore에 올릴 예정.
struct StationInfo: FireStoreCodable, SubwayModelIdentifier {
    let id = UUID().uuidString
    let subwayId: Int
    let subwayNm: String
    /// 역 ID
    let statnId: Int
    /// 역명
    let statnNm: String
}

/// MainList를 구성하는 SubwayLine 모델
/// FireStore에서 fetch해온다.
struct SubwayLineColor: FireStoreCodable {
    let subwayId: String
    let subwayNm: String
    let lineColorHexCode: String
}

extension SubwayLineColor {
    var lineColor: Color {
        return Color(hex: lineColorHexCode)
    }
}

struct TestSubwayLineColor: FireStoreCodable, Identifiable {
    var id = UUID().uuidString
    let subwayId: String
    let subwayNm: String
    let lineColorHexCode: String
}

extension TestSubwayLineColor {
    var lineColor: Color {
        return Color(hex: lineColorHexCode)
    }
}

extension TestSubwayLineColor {
    static var tempData: [Self] {
        return [.init(subwayId: "1001", subwayNm: "1호선", lineColorHexCode: "#263B96"),
                .init(subwayId: "1002", subwayNm: "2호선", lineColorHexCode: "#3CB44A"),
                .init(subwayId: "1003", subwayNm: "3호선", lineColorHexCode: "#F06F01"),
                .init(subwayId: "1004", subwayNm: "4호선", lineColorHexCode: "#2C9EDE"),
                .init(subwayId: "1005", subwayNm: "5호선", lineColorHexCode: "#8836DF"),
                .init(subwayId: "1006", subwayNm: "6호선", lineColorHexCode: "#B5500A")]
    }
}

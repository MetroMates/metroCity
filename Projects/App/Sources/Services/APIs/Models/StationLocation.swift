// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation

struct StationLocation: FireStoreCodable {
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

extension StationLocation {
    static var mockList: [StationLocation] = [
        .init(crdntX: 126.989134, crdntY: 37.463873, route: "4호선", statnId: 434, statnNm: "남태령"),
        .init(crdntX: 126.981651, crdntY: 37.476955, route: "4호선", statnId: 433, statnNm: "사당"),
        .init(crdntX: 126.981989, crdntY: 126.980347, route: "4호선", statnId: 432, statnNm: "총신대입구(이수)"),
        .init(crdntX: 126.980347, crdntY: 37.502852, route: "4호선", statnId: 431, statnNm: "동작(현충원)"),
        .init(crdntX: 126.974733, crdntY: 37.522295, route: "4호선", statnId: 430, statnNm: "이촌(국립중앙박물관)"),
        .init(crdntX: 126.967894, crdntY: 37.52917, route: "4호선", statnId: 429, statnNm: "신용산"),
        .init(crdntX: 126.9726, crdntY: 37.534075, route: "4호선", statnId: 428, statnNm: "삼각지"),
        .init(crdntX: 126.972106, crdntY: 37.54456, route: "4호선", statnId: 427, statnNm: "숙대입구(갈월)"),
        .init(crdntX: 126.972556, crdntY: 37.55281, route: "4호선", statnId: 426, statnNm: "서울역"),
        .init(crdntX: 126.978246, crdntY: 37.558514, route: "4호선", statnId: 425, statnNm: "회현(남대문시장)"),
        .init(crdntX: 126.986325, crdntY: 37.560989, route: "4호선", statnId: 424, statnNm: "명동"),
        .init(crdntX: 126.99408, crdntY: 37.561207, route: "4호선", statnId: 423, statnNm: "충무로"),
        .init(crdntX: 127.007885, crdntY: 37.565133, route: "4호선", statnId: 422, statnNm: "동대문역사문화공원"),
        .init(crdntX: 127.009287, crdntY: 37.57093, route: "4호선", statnId: 421, statnNm: "동대문"),
        .init(crdntX: 127.001844, crdntY: 37.582336, route: "4호선", statnId: 420, statnNm: "혜화"),
        .init(crdntX: 127.006221, crdntY: 37.588458, route: "4호선", statnId: 419, statnNm: "한성대입구(삼선교)"),
        .init(crdntX: 127.016441, crdntY: 37.592612, route: "4호선", statnId: 418, statnNm: "성신여대입구(돈암)"),
        .init(crdntX: 127.025053, crdntY: 37.603407, route: "4호선", statnId: 417, statnNm: "길음"),
        .init(crdntX: 127.030053, crdntY: 37.613292, route: "4호선", statnId: 416, statnNm: "미아사거리"),
        .init(crdntX: 127.025983, crdntY: 37.62667, route: "4호선", statnId: 415, statnNm: "미아(서울사이버대학)"),
        .init(crdntX: 127.025732, crdntY: 37.638052, route: "4호선", statnId: 414, statnNm: "수유(강북구청)"),
        .init(crdntX: 127.034709, crdntY: 37.648627, route: "4호선", statnId: 413, statnNm: "쌍문"),
        .init(crdntX: 127.047274, crdntY: 37.653088, route: "4호선", statnId: 412, statnNm: "창동"),
        .init(crdntX: 127.063276, crdntY: 37.65627, route: "4호선", statnId: 411, statnNm: "노원"),
        .init(crdntX: 127.073572, crdntY: 37.660878, route: "4호선", statnId: 410, statnNm: "상계"),
        .init(crdntX: 127.079066, crdntY: 37.670272, route: "4호선", statnId: 409, statnNm: "당고개"),
        .init(crdntX: 126.765844, crdntY: 37.338212, route: "안산선", statnId: 1760, statnNm: "신길온천")
    ]
}

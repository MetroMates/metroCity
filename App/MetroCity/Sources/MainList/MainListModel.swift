// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 12:30 린다꿀꿀이🐷

import SwiftUI

/*
    1. 전체 호선 및 역정보 불러온다.
    2. 전체 역에 대하여 역이름의 중복을 제거한다. (역 번호(statnId) 기준)
    2-1. subwayID
    3. 전체 호선정보를 담을 객체 생성 후 담는다. (subwayID)
    4.
 */

/// MainList모델
/// 전체 호선 리스트
struct MainListModel: SubwayModelIdentifier {
    let id: String = UUID().uuidString
    /// 지하철 몇호선인지(ID)
    let subwayID: String
    /// 지하철 호선 명
    let subwayNm: String
}

extension MainListModel {
// 인스턴스를 생성할때 공통적으로 들어가는 부분이 있다면 이런식으로 static method로 따로 만들어서 관리해주는것도 좋다.
//    static func make() -> Self {
//        return .init(statnID: <#T##String#>,
//                     statnNm: <#T##String#>,
//                     subwayID: <#T##String#>,
//                     updnLine: <#T##String#>,
//                     barvlDt: <#T##String#>)
//    }
}

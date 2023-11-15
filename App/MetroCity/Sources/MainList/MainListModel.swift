// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 12:30 린다꿀꿀이🐷

import SwiftUI

/// MainList모델
struct MainListModel: Identifiable {
    let id: String = UUID().uuidString
    /// 현재 역ID
    let statnID: String
    /// 현재 역명
    let statnNm: String
    /// 지하철 몇호선인지
    let subwayID: String
    
    /// 상,하행선 구분 (0 : 상행/내선, 1 : 하행/외선)
    let updnLine: String
    
    /// 열차 도착예정시간
    let barvlDt: String

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

// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct Temp: SubwayModelIdentifier {
    let id: String = UUID().uuidString
    /// 현재 지하철역ID
    let statnId: String
    /// 현재 지하철역명
    let statnNm: String
//    / 이전 지하철역ID
//    / 이전 지하철역명
//    / 다음 지하철역ID
//    / 다음 지하철역명
//    / 상하행선 구분 (0: 상행/내선, 1: 하행/외선)
//    / 도착지방면 (성수행(목적지역) - 구로디지털단지방면(다음역))
//    / 도착코드  (0:진입, 1:도착, 2:출발, 3:전역출발, 4:전역진입, 5:전역도착, 99:운행중)
//    / 열차종류(급행, ITX, 일반, 특급)
}

/// 역정보 (호선 내부용) -> 호선에 대한 현재역, 이전역, 다음역
///
/// Arrived에서 데이터 가져올수 있다.
struct MyStation: SubwayModel {
    /// 현재역 id ( statnId )
    let nowSt: Int
    /// 현재역명 (선택한역)
    var nowStNm: String
    /// 상행역 id ( statnFid )
    let upSt: Int
    /// 상행역명
    let upStNm: String
    /// 하행역  id ( statnTid )
    let downSt: Int
    /// 하행역명
    let downStNm: String

}

extension MyStation {
    static var emptyData: Self {
        return .init(nowSt: 0, nowStNm: "NONE",
                     upSt: 0, upStNm: "",
                     downSt: 0, downStNm: "")
    }
    
    static func nowStNmInit(id: Int, name: String) -> Self {
        return .init(nowSt: id,
                     nowStNm: name,
                     upSt: 0,
                     upStNm: "",
                     downSt: 0,
                     downStNm: "")
    }
    
}

/// 실시간 지하철 위치 정보
/// 내가 현재 선택한 역 기준으로 데이터 가져와야 함.
///
/// MyStation의 이전, 다음, 현재 역 ID 값을 기준으로 실시간 열차위치를 가진다.
/// MyStation데이터가 기준이 되고, 그 데이터가 변경되면 RealTimeSubway의 데이터도 변경되어야 한다.
///
///
/// Position에서 데이터 가져올수 있다.
struct RealTimeSubway: SubwayModelIdentifier {
    let id = UUID()
    /// 상, 하행
    let updnLine: String
    /// 열차 번호
    let trainNo: String
    /// 열차 종류 ( 급행, ITX, 일반, 특급 )
    let trainType: String
    /// 정렬 순서 1 (몇번째 전역에 위치한지 정보)
    let stCnt: Int
    /// 정렬순서 2 (해당역에 몇번째로 들어오는 열차인지) -> 데이터가 신뢰성은 없음.
    let sortOrder: Int
    /// 표출메세지 : 전역 도착, 130초전 등등
    let message: String
    /// 무슨행 ( 광운대행, 청량ㅇ리행 )
    let trainDestiStation: String
    /// 지하철 위치 노선에 올릴 CGFloat
    let trainLocation: CGFloat
}

extension RealTimeSubway {
    var updnIndex: String {
        updnLine == "상행" ? "0" : "1"
    }
    var trainTypeIndex: String {
        switch trainType {
        case "급행":
            return "1"
        case "ITX", "일반":
            return "0"
        case "특급":
            return "7"
        default:
            return "0"
        }
    }
    
    static var emptyData: Self {
        return .init(updnLine: "", trainNo: "", trainType: "", stCnt: 0, sortOrder: 0, message: "", trainDestiStation: "", trainLocation: 0)
    }
    
    // 여러개 들어올 예정.
    static var list: [Self] {
        return []
    }
    
}

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

/*
    필요한 필드값들
    호선ID, 호선명, ( 역ID, 역명 => 호선에 대한 ), 호선색상(=라인색상),

    현재 역, 이전역, 다음역, 지하철상태, 데이터수신시간, ( 무슨행인지(ex:소요산행, 진접행) = 종점 ), 급행여부

    필요한 DTO Data Transfer Object
    1. 해당호선에 대한 모든 역정보
       statnID, statnNM
    2. 해당호선 색상, 전반적인 UI의 색상
 
 */

/// 호선 정보 ( subwayList의 값에 따라서 넣어준다. ) 여러개 있을수 있음.
///
/// Arrived에서 가져온다.
/// - subwayID: 호선ID
/// - subwayNm: 호선명
/// - hosunColor: 호선대표색상 (ex: 4호선 하늘색, 1호선 파란색)
/// - lineColor: 실시간 열차위치를 표시할 라인 색상
// struct HosunInfo: SubwayModelIdentifier {
//    let id: String = UUID().uuidString
//    let subwayID: String
//    let subwayNm: String
//    let hosunColor: Color
//    let lineColor: Color
//}
//
// extension HosunInfo {
//    static var emptyData: Self {
//        return .init(subwayID: "",
//                     subwayNm: "",
//                     hosunColor: .black,
//                     lineColor: .black)
//    }
// }

///// 현재역 열차 도착 상태 (0:진입, 1:도착, 2:출발, 3:전역출발, 4:전역진입, 5:전역도착, 99:운행중)
// let nowStatus: String
///// 상하행선구분  (0 : 상행/내선, 1 : 하행/외선)  상행이면 다음역을 상행에 이전역을 하행에 배치.
// let updnLine: String
///// 열차종류 (급행,ITX,일반,특급)
// let trainType: String

/// 역정보 (호선 내부용) -> 호선에 대한 현재역, 이전역, 다음역
///
/// Arrived에서 데이터 가져올수 있다.
struct MyStation: SubwayModel {
    /// 현재역 id ( statnId )
    let nowSt: Int
    /// 현재역명 (선택한역)
    let nowStNm: String
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
}

/*
    
 */

/// 실시간 지하철 위치 정보
/// 내가 현재 선택한 역 기준으로 데이터 가져와야 함.
///
/// MyStation의 이전, 다음, 현재 역 ID 값을 기준으로 실시간 열차위치를 가진다.
/// MyStation데이터가 기준이 되고, 그 데이터가 변경되면 RealTimeSubway의 데이터도 변경되어야 한다.
///
///
/// Position에서 데이터 가져올수 있다.
struct RealTimeSubway: SubwayModel {
    let statnNm: String
}

extension RealTimeSubway {
    static var emptyData: Self {
        return .init(statnNm: "값이 없음")
    }
    
    // 여러개 들어올 예정.
    static var list: [Self] {
        return []
    }
    
}

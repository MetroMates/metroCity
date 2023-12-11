// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

// upSt, downSt 모두 배열로 만들어주기로 한다.
/// 역정보 (호선 내부용) -> 호선에 대한 현재역, 이전역, 다음역
///
/// Arrived에서 데이터 가져올수 있다.
struct MyStation: SubwayModel {
    /// 현재역 id ( statnId )
    let nowSt: Int
    /// 현재역명 (선택한역)
    var nowStNm: String
    /// 상행역 id ( statnFid )
    let upSt: [Int]
    /// 상행역명
    let upStNm: [String]
    /// 하행역  id ( statnTid )
    let downSt: [Int]
    /// 하행역명
    let downStNm: [String]
}

extension MyStation {
    static var emptyData: Self {
        return .init(nowSt: 0, nowStNm: "NONE",
                     upSt: [], upStNm: [],
                     downSt: [], downStNm: [])
    }
    
    static func nowStNmInit(id: Int, name: String) -> Self {
        return .init(nowSt: id,
                     nowStNm: name,
                     upSt: [],
                     upStNm: [],
                     downSt: [],
                     downStNm: [])
    }
    
    var downStationName: String {
        let downArray: [String] = self.downStNm // ["가산디지털단지", "구일"] // self.downStNm 자리. -> [String]타입으로 변환 예정. 23.12.11
        var resultString: String
        if downArray.count > 1 {
            resultString = downArray.joined(separator: "/")
        } else {
            resultString = downArray.first ?? ""
        }
        return resultString
    }
    
    var upStationName: String {
        let downArray: [String] = self.upStNm // ["가산디지털단지", "구일"]
        var resultString: String
        if downArray.count > 1 {
            resultString = downArray.joined(separator: "/")
        } else {
            resultString = downArray.first ?? ""
        }
        return resultString
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
//    /// 정렬순서 2 (해당역에 몇번째로 들어오는 열차인지) -> 데이터가 신뢰성은 없음.
//    let sortOrder: Int
    /// 표출메세지 : 전역 도착, 130초전 등등
    let message: String
    /// 무슨행 ( 광운대행, 청량ㅇ리행 )
    let trainDestiStation: String
    /// 지하철 위치 노선에 올릴 CGFloat
    let trainLocation: CGFloat
    /// 도착 코드
    let arvlCode: String
    /// 열차 위치기준 코드
    let arvlCaseCode: ArvlCase
    /// 열차위치 변경여부
    let isChange: Bool
}

extension RealTimeSubway {
    var updnIndex: String {
        if updnLine == "상행" || updnLine == "외선" {
            return "0"
        }
        return "1"
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
        return .init(updnLine: "",
                     trainNo: "",
                     trainType: "",
                     stCnt: 0,
                     message: "",
                     trainDestiStation: "",
                     trainLocation: 0,
                     arvlCode: "-1", 
                     arvlCaseCode: .none,
                     isChange: true)
    }
    
}

enum ArvlCase: String {
    case start
    case middle
    case end
    case none
    
    var subwayDistanceRate: CGFloat {
        switch self {
        case .start:
            return 0.95
        case .middle:
            return 0.7
        case .end:
            return 0.5
        case .none:
            return 0
        }
    }
    
    static func arvlCDConvert(_ code: ArvlCD) -> Self {
        switch code {
        case .five, .three:
            return .start
        case .zero:
            return .middle
        case .one, .two:
            return .end
        default:
            return .none
        }
    }
}

/// 전철정보 Api ArvlCD info
enum ArvlCD: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case ninetynine = "99"
    
    var name: String {
        switch self {
        case .zero:
            return "당역 진입"
        case .one:
            return "당역 도착"
        case .two:
            return "출발"
        case .three:
            return "전역 출발"
        case .four:
            return "전역 진입"
        case .five:
            return "전역 도착"
        case .ninetynine:
            return "운행중"
        }
    }
}

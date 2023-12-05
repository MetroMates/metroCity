// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import Foundation

/*
    서울시 지하철 실시간 열차 위치정보
 */

// MARK: - Position
struct Position: SubwayModel2Server {
    let errorMessage: ErrorMessage
    let realtimePositionList: [RealtimePositionList]
}

// MARK: - RealtimePositionList
struct RealtimePositionList: Codable {
    let beginRow, endRow, curPage, pageRow: JSONNull?
    let totalCount, rowNum, selectedCount: Int
    let subwayID, subwayNm, statnID, statnNm: String
    let trainNo, lastRecptnDt, recptnDt, updnLine: String
    let statnTid, statnTnm, trainSttus, directAt: String
    let lstcarAt: String
    
    enum CodingKeys: String, CodingKey {
        case beginRow, endRow, curPage, pageRow, totalCount, rowNum, selectedCount
        case subwayID = "subwayId"
        case subwayNm
        case statnID = "statnId"
        case statnNm, trainNo, lastRecptnDt, recptnDt, updnLine, statnTid, statnTnm, trainSttus, directAt, lstcarAt
    }
}

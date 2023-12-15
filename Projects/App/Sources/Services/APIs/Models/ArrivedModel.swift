// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import Foundation

/*
    서울 지하철 실시간 도착정보
 */

// MARK: - Arrived
struct Arrived: SubwayModel2Server {
    let errorMessage: ErrorMessage
    let realtimeArrivalList: [RealtimeArrivalList]
}

// MARK: - RealtimeArrivalList
struct RealtimeArrivalList: Codable {
    let beginRow, endRow, curPage, pageRow: JSONNull?
    let totalCount, rowNum, selectedCount: Int
    let subwayID: String
    let subwayNm: JSONNull?
    let updnLine, trainLineNm: String
    let subwayHeading: JSONNull?
    let statnFid, statnTid, statnID, statnNm: String
    let trainCo: JSONNull?
    let trnsitCo, ordkey, subwayList, statnList: String
    let btrainSttus, barvlDt, btrainNo, bstatnID: String
    let bstatnNm, recptnDt, arvlMsg2, arvlMsg3: String
    let arvlCD: String

    enum CodingKeys: String, CodingKey {
        case beginRow, endRow, curPage, pageRow, totalCount, rowNum, selectedCount
        case subwayID = "subwayId"
        case subwayNm, updnLine, trainLineNm, subwayHeading, statnFid, statnTid
        case statnID = "statnId"
        case statnNm, trainCo, trnsitCo, ordkey, subwayList, statnList, btrainSttus, barvlDt, btrainNo
        case bstatnID = "bstatnId"
        case bstatnNm, recptnDt, arvlMsg2, arvlMsg3
        case arvlCD = "arvlCd"
    }
}

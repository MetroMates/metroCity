// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import Foundation

/// APIKEY Bundle.main
enum APIKEY: String {
    case subway = "SUBWAY_API_KEY"
}
/// URL 주소
enum URLAddress: String {
    case subwayArrive = "realtimeStationArrival"
    case subwayLocation = "realtimePosition"
}

/// 지하철호선
enum SubwayLine: String, CaseIterable {
    case line1001 = "1호선"
    case line1002 = "2호선"
    case line1003 = "3호선"
    case line1004 = "4호선"
    case line1005 = "5호선"
    case line1006 = "6호선"
    case line1007 = "7호선"
    case line1008 = "8호선"
    case line1009 = "9호선"
    case line1061 = "중앙선"
    case line1063 = "경의중앙선"
    case line1065 = "공항철도"
    case line1067 = "경춘선"
    case line1075 = "수의분당선"
    case line1077 = "신분당선"
    case line1092 = "우이신설선"
}

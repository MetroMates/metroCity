// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import Foundation

/// APIKEY Bundle.main
enum APIKEY: String {
    case subway = "SUBWAY_API_KEY"
}

/// URL 주소
enum URLAddress: String {
    case subwayArrive = "realtimeStationArrival"
    case subwayPosition = "realtimePosition"
}

/// 지하철호선 총 16호선
enum SubwayLine: String, CaseIterable {
    case line1001 = "1001"
    case line1002 = "1002"
    case line1003 = "1003"
    case line1004 = "1004"
    case line1005 = "1005"
    case line1006 = "1006"
    case line1007 = "1007"
    case line1008 = "1008"
    case line1009 = "1009"
    case line1061 = "1061"
    case line1063 = "1063"
    case line1065 = "1065"
    case line1067 = "1067"
    case line1075 = "1075"
    case line1077 = "1077"
    case line1092 = "1092"
    
}

extension SubwayLine {
    var subwayName: String {
        switch self {
        case .line1001:
            return "1호선"
        case .line1002:
            return "2호선"
        case .line1003:
            return "3호선"
        case .line1004:
            return "4호선"
        case .line1005:
            return "5호선"
        case .line1006:
            return "6호선"
        case .line1007:
            return "7호선"
        case .line1008:
            return "8호선"
        case .line1009:
            return "9호선"
        case .line1061:
            return "중앙선"
        case .line1063:
            return "경의중앙선"
        case .line1065:
            return "공항철도"
        case .line1067:
            return "경춘선"
        case .line1075:
            return "수의분당선"
        case .line1077:
            return "신분당선"
        case .line1092:
            return "우이신설선"
        }
    }
    
}

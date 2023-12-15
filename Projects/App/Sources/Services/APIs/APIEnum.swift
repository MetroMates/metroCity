// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import SwiftUI

/// APIKEY Bundle.main
enum APIKEY: String {
    case subway = "SUBWAY_API_KEY"
}

/// URL 주소
enum URLAddress: String {
    case subwayArrive = "realtimeStationArrival"
    case subwayPosition = "realtimePosition"
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오전 01:59 꿀꿀🐷

import Foundation

/// api통신 Fetch 타이머 기준
let gapiFetchTimeSecond: Double = 3600.0

/// 열차모형 초당 움직이는 거리수 (x 값)
enum GtrainSpeed {
    static let start: Double = 0.5
    static let middle: Double = 0.3
    static let end: Double = 0.05
}

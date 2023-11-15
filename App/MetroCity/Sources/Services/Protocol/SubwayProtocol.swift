// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import SwiftUI

// API통신시 errorMessage는 무조건 있어야하기때문에 protocol로 따로 분리하여 관리.
protocol SubwayModeling: Codable {
    var errorMessage: ErrorMessage { get }
}

// ViewModel 클래스에 따르게 만들고 중간 Repository를 만들어서 그 안에서 실행시킨다...? 흠...
protocol SubwayInfos: AnyObject {
    func fetch()
}

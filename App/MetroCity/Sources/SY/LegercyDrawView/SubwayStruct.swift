// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 12:21 꿀꿀🐷

import SwiftUI

struct SubwayLine {
    var name: String
    var color: Color
    var stations: [SubwayStation]
}

struct SubwayStation: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var coordinates: CGPoint
}

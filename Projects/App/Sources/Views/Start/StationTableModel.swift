// Copyright © 2024 TDS. All rights reserved. 2024-02-13 화 오후 02:46 꿀꿀🐷

import Foundation

// MARK: - PositionElement
struct StationTableElement: Codable, Identifiable {
    let id, hosun, statNm, weekAt: String
    let direction, fastAt, arriveTime, startTime: String
    let destination: String
}

typealias StationTable = [StationTableElement]

extension StationTable {
    static let mockDatas: Self = .init(repeating: .init(id: "0",
                                                        hosun: "",
                                                        statNm: "",
                                                        weekAt: "",
                                                        direction: "",
                                                        fastAt: "",
                                                        arriveTime: "",
                                                        startTime: "",
                                                        destination: "Data없음"), count: 1)
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import SwiftUI
import Combine

/// 즐겨찾기 ViewModel
final class BookMarkVM: MainListVM {
    
    @Published var stationInfos: [StationInfo] = []
    
    
    var groupedStationInfos: [(key: String, value: [StationInfo])] {
        Array(Dictionary(grouping: stationInfos, by: { $0.subwayNm }).sorted(by: { $0.key < $1.key }))
    }
    
    override init(useCase: MainListUseCase, startVM: StartVM) {
        super.init(useCase: useCase, startVM: startVM)
        self.isSearchShow = false
    }
    
    func fetchBookMark() {
        let coreDataManger = CoreDataManger.shared
        let bookMarkEntity = coreDataManger.retrieve(type: BookMarkEntity.self)
        self.subwayLineInfos = bookMarkEntity.flatMap { info -> [SubwayLineColor] in
            var infos: [SubwayLineColor] = []
            infos.append(.init(subwayId: info.statnId, subwayNm: info.statnNm ?? "", lineColorHexCode: info.lineColor ?? ""))
            return infos
        }.sorted { $0.subwayId < $1.subwayId }
        
        self.stationInfos = bookMarkEntity.flatMap { info -> [StationInfo] in
            var infos: [StationInfo] = []
            infos.append(.init(subwayId: info.statnId, subwayNm: info.statnNm ?? "", statnId: info.subwayId, statnNm: info.subwayNm ?? ""))
            return infos
        }.sorted { $0.subwayId < $1.subwayId }
    }
    
    func subwayLine(_ id: Int32) -> SubwayLineColor {
        guard let subwayLine = subwayLineInfos.first(where: { $0.subwayId == id }) else { return .emptyData }
        return subwayLine
    }
    func subwayColor(_ id: Int32) -> Color {
        guard let subwayColor = subwayLineInfos.first(where: { $0.subwayId == id }) else { return .primary }
        return subwayColor.lineColor
    }
    func subwayHexCode(_ id: Int32) -> String {
        guard let subwayHexCode = subwayLineInfos.first(where: { $0.subwayId == id }) else { return "" }
        return subwayHexCode.lineColorHexCode
    }
}

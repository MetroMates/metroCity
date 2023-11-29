// Copyright © 2023 TDS. All rights reserved. 2023-11-28 화 오후 05:50 꿀꿀🐷

import Foundation
import Combine

final class StartVM {
    private let dataManager: DataManager!
//    private let stationInfoSubject = PassthroughSubject<[StationInfo], Never>()
//    private let lineInfoSubject = PassthroughSubject<[SubwayLineColor], Never>()
//    private let locInfoSubject = PassthroughSubject<[StationLocation], Never>()
    private let stationInfoSubject = CurrentValueSubject<[StationInfo], Never>([])
    private let lineInfoSubject = CurrentValueSubject<[SubwayLineColor], Never>([])
    private let locInfoSubject = CurrentValueSubject<[StationLocation], Never>([])

    init(type: DataType) {
        debugPrint("1️⃣ \(type)")
        switch type {
        case .real:
            dataManager = RealDataManager()
        case .test:
            dataManager = TestDataManager()
        }
        
        fetchDatas()
    }
    
    func dataPublisher() -> AnyPublisher<(Array<StationInfo>, Array<SubwayLineColor>, Array<StationLocation>), Never> {

        return stationInfoSubject.zip(lineInfoSubject, locInfoSubject)
            .share()
            .eraseToAnyPublisher()
    }
    
    private func fetchDatas() {
        dataManager.fetchDatas(statType: StationInfo.self,
                               subwayLineType: SubwayLineColor.self,
                               locationInfoType: StationLocation.self) { statInfos, lineInfos, locInfos in

            // 여기의 send부분이 해당 publisher에 구독, 즉 sink가 달리기도 전에 먼저 실행이 되게 되면
            // 추후 해당 publisher는 발행자로서의 기능을 상실하게 된다. 그래서 Passthrough가 아닌 CurrentValueSubject로 진행.
            self.stationInfoSubject.send(statInfos)
            self.lineInfoSubject.send(lineInfos)
            self.locInfoSubject.send(locInfos)
        }
    }
    
}

extension StartVM {
    enum DataType {
        case test, real
    }
}

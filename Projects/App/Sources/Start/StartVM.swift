// Copyright © 2023 TDS. All rights reserved. 2023-11-28 화 오후 05:50 꿀꿀🐷

import Foundation

/// Data 싱글톤
final class StartVM: ObservableObject {
    private let dataManager: DataManager!
    @Published var stationInfos = [StationInfo]()
    @Published var lineInfos = [SubwayLineColor]()
    @Published var locationInfos = [StationLocation]()
    
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
    
    func fetchDatas() {
        dataManager.fetchDatas(statType: StationInfo.self,
                               subwayLineType: SubwayLineColor.self,
                               locationInfoType: StationLocation.self) { statInfos, lineInfos, locInfos in
            self.stationInfos = statInfos
            self.lineInfos = lineInfos
            self.locationInfos = locInfos
            
//            print("1️⃣ line ", lineInfos)
        }
    }
}

extension StartVM {
    enum DataType {
        case test, real
    }
}

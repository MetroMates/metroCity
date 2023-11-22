// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// MainDetailViewModel의 비즈니스로직 관리
final class MainDetailUseCase {
    private let repository: SubwayRepositoryFetch
    
    init(repo: SubwayRepositoryFetch) {
        self.repository = repo
    }
    
    func getStationData(vm: MainDetailVM, _ value: String) -> MyStation {
        let stations = StationInfo.testList
        guard !stations.isEmpty else { return .emptyData }
        
        // 역명이 같고 호선이 클릭한 호선의 데이터를 찾아온다. -> 1개만 나와야 정상.
        let newDatas = stations.filter { st in
            st.statnNm == value && st.subwayId == vm.hosunInfo.subwayId
        }.first
        
        if let newDatas {
            // 상행일때 -1
            let upSt = newDatas.statnId - 1
            let downSt = newDatas.statnId + 1
            
            let upStNm = stations.filter { $0.statnId == upSt }.first?.statnNm ?? "[none]"
            let downStNm = stations.filter { $0.statnId == downSt }.first?.statnNm ?? "[none]"
            
            return .init(nowSt: newDatas.statnId,
                         nowStNm: value,
                         beforeSt: upSt,
                         beforeStNm: upStNm,
                         afterSt: downSt,
                         afterStNm: downStNm)
        }
        
        return .emptyData
    }
    
    // Never타입은 못씀. 에러를 발생시키지 않기 때문...!!
    func recievePublisher(whereData: String) -> AnyPublisher<RealTimeSubway, Error> {
        return repository.receivePublisher(type: Arrived.self, urlType: .subwayArrive, whereData: whereData)
            .flatMap { rdata -> AnyPublisher<RealTimeSubway, Error> in
                if let temp = rdata.realtimeArrivalList.first {
                    let station = RealTimeSubway(statnNm: temp.statnNm)
                    
                    return Just(station).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                return Fail(error: StatusError.ERR100).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
}

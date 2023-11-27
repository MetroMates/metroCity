// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 06:43 꿀꿀🐷

import Foundation
import Combine

// ViewModel에서 특정 동작이 일어났을경우의 비즈니스 로직이 동작하는 클래스
// 비즈니스 로직이란 View = 즉 UI와 관련되지 않은 모든 로직을 일컫는다.
final class MainListUseCase {
    // SubwayRepositoryFetch 프로토콜을 채택하는 레포지토리를 외부에서 생성하여 주입받는다.
    // 특정 Repository 객체(타입)를 의존하지 않음을 뜻함. => 해당 추상화프로토콜을 따르는 어떤 Repository라도 사용이 가능함을 의미.
    private let repository: SubwayRepositoryFetch
    /// 위치class 매니저
    private let locationManager: LocationManager = .init()
    
    /// 현재 나의 위치 정보
    private var location: Location = .init(crdntX: 0, crdntY: 0)
    private var anyCancel: Set<AnyCancellable> = []
    
    private let stInfosSubject = PassthroughSubject<[StationInfo], Never>()
    private let stLocInfosSubject = PassthroughSubject<[StationLocation], Never>()
    
    /// 나와 가장 가까운 역명
    @Published var nearLocStationName: String = ""
    /// 역 위치 정보( 위도, 경도 )
    private var stLocInfos = [StationLocation]()
    
    init(repo: SubwayRepositoryFetch) {
        self.repository = repo
    }
    
    deinit {
        anyCancel.forEach { $0.cancel() }
    }
    
    /// GPS 기반하여 가장 가까운 역이름, 역코드 반환
    func getNearStation() {
        self.fetchLocation()
    }

    func getNearStationLineInfos(statName: String) -> [StationInfo] {
        return StationInfo.testList.filter { info in
            info.statnNm == statName
        }
    }
    
    /// MainListVM을 통해서 MinaListView가 onAppear 될때 한번만 호출해줄 것.
    func dataFetch(vm: MainListVM) async {
        // 정보 Fetch
        print("🍜", "MainListUseCase init & fetch")
        
        if StationInfo.list.isEmpty {
            StationInfo.list = await self.fetchStationInfos() // static 변수에 할당.
        }
        
        print("🍜", StationInfo.list.count)
        
        if SubwayLineColor.list.isEmpty {
            SubwayLineColor.list = await self.fetchLineColorInfos()
        }
        print("🍜", SubwayLineColor.list.count)
        
        await MainActor.run {
            vm.subwayLines = SubwayLineColor.list
        }
        
        if stLocInfos.isEmpty {
            self.stLocInfos = await self.fetchLocationInfos()
        }
        
        // 데이터는 잘 받아옴.
        stInfosSubject.send(StationInfo.list)
        stLocInfosSubject.send(stLocInfos)
    }
    
}

// MARK: - Private Methods
extension MainListUseCase {
    /// 나의 위치 정보 구독
    private func fetchLocation() {
        locationManager.fetchUserLocation()
        // 여기서는 combineLatest를 사용해야 하는 이유: stInfosSubject, stLocInfosSubject는 초반에 한번만 발행이 될것이기 때문.
        locationManager.locationPublisher.combineLatest(stInfosSubject, stLocInfosSubject)
            .sink { (myLoc, _, stLoc) in
                self.filterStationName(myLoc: myLoc, statnLoc: stLoc)
            }
            .store(in: &anyCancel)
    }
    
    // 기존의 역정보를 가지고 역이름을 걸러준다.
    private func filterStationName(myLoc: Location, statnLoc: [StationLocation]) {
        let closeStName = locationManager.calculateDistance(userLoc: myLoc, statnLoc: statnLoc, distance: 3000)
        print("🍜", closeStName)
        let tempStationInfo = StationInfo.list.filter { $0.statnNm.contains(closeStName) }
        print("🍜", tempStationInfo)
        self.nearLocStationName = tempStationInfo.first?.statnNm ?? ""
        print("🍜", nearLocStationName)
    }
    
    /// 역정보 Fetch
    private func fetchStationInfos() async -> [StationInfo] {
        return await repository.fetchingData(type: StationInfo.self, colName: "StationInfo")
    }
    
    /// 역위치 정보 Fetch
    private func fetchLocationInfos() async -> [StationLocation] {
        return await repository.fetchingData(type: StationLocation.self, colName: "StationLocation")
    }
    
    /// 역라인정보 Fetch
    private func fetchLineColorInfos() async -> [SubwayLineColor] {
        return await repository.fetchingData(type: SubwayLineColor.self, colName: "SubwayLineColor")
    }
    
}

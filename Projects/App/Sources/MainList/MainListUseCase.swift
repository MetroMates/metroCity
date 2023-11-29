// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 06:43 꿀꿀🐷

import Foundation
import Combine

// ViewModel에서 특정 동작이 일어났을경우의 비즈니스 로직이 동작하는 클래스
// 비즈니스 로직이란 View = 즉 UI와 관련되지 않은 모든 로직을 일컫는다.
// UseCase에서는 Published를 하지 않는다. 즉, Observabled를 채택하여 사용하지 않는다.
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
    private let nearStationNameSubject = PassthroughSubject<String, Never>()
    
//    /// 나와 가장 가까운 역명
//    @Published var nearLocStationName: String = ""
//    /// 역 위치 정보( 위도, 경도 )
//    private var stLocInfos = [StationLocation]()
    
    init(repo: SubwayRepositoryFetch) {
        self.repository = repo
        self.subscribe() // send로 보내지 않으면 어차피 방출은 발생하지않는다. init할때 미리 구독을 걸어주는게 좋을듯.
    }
    
    deinit {
        anyCancel.forEach { $0.cancel() }
    }
    
    /// GPS 기반하여 가장 가까운 역이름, 역코드 반환
    func startFetchNearStationFromUserLocation() {
        locationManager.fetchUserLocation()
    }

    func filterdLineInfosFromSelectStationName(statName: String) -> [StationInfo] {
        return StationInfo.list.filter { info in
            info.statnNm == statName
        }
    }
    
    /// MainListVM을 통해서 MinaListView가 onAppear 될때 한번만 호출해줄 것.
    func dataFetchs(vm: MainListVM) async {
        var stLocInfos = [StationLocation]()
        
        // 정보 Fetch
        print("🍜", "MainListUseCase init & fetch")
        
        if StationInfo.list.isEmpty {
            StationInfo.list = await self.fetchStationInfos() // static 변수에 할당.
            if !StationInfo.list.isEmpty {
                stInfosSubject.send(StationInfo.list)
            }
        }

        if stLocInfos.isEmpty {
            stLocInfos = await self.fetchLocationInfos()
            
            if !stLocInfos.isEmpty {
                stLocInfosSubject.send(stLocInfos)
            }
        }
        
        if SubwayLineColor.list.isEmpty {
            SubwayLineColor.list = await self.fetchLineColorInfos()
        }
        
        await MainActor.run {
            vm.subwayLineInfos = SubwayLineColor.list
        }
        
        nearStationNameSubject
            .receive(on: DispatchQueue.main)
            .sink { statNm in
                vm.nearStNamefromUserLocation = statNm
            }.store(in: &anyCancel)
        
    }
    
}

// MARK: - Private Methods
extension MainListUseCase {
    /// 구독 메서드
    private func subscribe() {
        // 여기서는 combineLatest를 사용해야 하는 이유: stInfosSubject, stLocInfosSubject는 초반에 한번만 발행이 될것이기 때문.
        // 이거 불안불안함. 테스트 여러번 해봐야할듯.
        locationManager.userLocationPublisher.zip(stInfosSubject, stLocInfosSubject)
            .sink { (myLoc, _, stLoc) in
                print("🍜 myLOC \(myLoc),  stLOC Cnt : \(stLoc.count)")
                self.findNearStationFromUserLocation(myLoc: myLoc, statnLoc: stLoc)
            }
            .store(in: &anyCancel)

    }
    
    // 유저의 위치에 가까운 역을 찾아서 역이름을 반환한다.
    private func findNearStationFromUserLocation(myLoc: Location, statnLoc: [StationLocation]) {
        let closeStName = locationManager.calculateDistance(userLoc: myLoc, statnLoc: statnLoc, distance: 3000)
        print("🍜 closeStName ", closeStName)
        
        let tempStationInfo = StationInfo.list.filter { $0.statnNm.contains(closeStName) }
        print("🍜", tempStationInfo)
        
        let nearStationName = tempStationInfo.first?.statnNm ?? ""
        nearStationNameSubject.send(nearStationName)
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

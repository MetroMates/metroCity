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
    private let locationManager = LocationManager.shared
    private var anyCancel: Set<AnyCancellable> = []
        
    // viewModel에서 구독. -> 근처역명 반환.
    let nearStationNameSubject = PassthroughSubject<String, Never>()
    
    init(repo: SubwayRepositoryFetch) {
        print("👻 MainListUseCase")
        self.repository = repo
    }
    
    deinit {
        anyCancel.forEach { $0.cancel() }
    }
    
    /// GPS 기반하여 가장 가까운 역이름, 역코드 반환
    func startFetchNearStationFromUserLocation() {
        locationManager.fetchUserLocation()
    }
    
    func userLocationSubscribe(statnLocInfos: [StationLocation]) {
        print("🍜 userLocationSubscribe  진입 (내부)")
        locationManager.userLocPublisher()
            .sink { loc in
                print("🍜 userLocationSubscribe 내부의 userLocationPublisher")
                self.findNearStationFromUserLocation(myLoc: loc,
                                                     statnLoc: statnLocInfos)
            }
            .store(in: &anyCancel)

    }
    
    func filterdLineInfosFromSelectStationName(totalStationInfo: [StationInfo],
                                               statName: String) -> [StationInfo] {
        return totalStationInfo.filter { info in
            info.statnNm == statName
        }
    }
    
}

// MARK: - Private Methods
extension MainListUseCase {
    // 유저의 위치에 가까운 역을 찾아서 역이름을 반환한다.
    private func findNearStationFromUserLocation(myLoc: Location, statnLoc: [StationLocation]) {
        print("🍜 userLoc ", myLoc)
        let closeStName = locationManager.calculateDistance(userLoc: myLoc, statnLoc: statnLoc, distance: 3000)
        print("🍜 closeStName ", closeStName, " 그리고 \(statnLoc.count)")

        let tempStationInfo = statnLoc.filter { $0.statnNm.contains(closeStName) }
        print("🍜", tempStationInfo)
        
        let nearStationName = tempStationInfo.first?.statnNm ?? ""
        
        print("🍜 near ", nearStationName)
        
        nearStationNameSubject.send(nearStationName)
    }
    
}

// Copyright © 2023 TDS. All rights reserved.23.11.09

import SwiftUI
import Combine

// View에서 이벤트가 발생 -> Presenter(ViewModel)에서 '무엇'인지 판단
// Presenter는 UseCase를 실행
// UseCase는 User와 Repository를 결합
// 각 Repository는 network, DB관련 Store에서 데이터 반환
// 다시 UI에 업데이트: Store -> Repository -> UseCase -> ViewModel -> View(UI)

// ViewModel에서는 View와 관련된 메서드(로직)만 작성한다.
/// 메인 리스트 ViewModel
final class MainListVM: ObservableObject {
    /// 유저위치에서 가장 가까운 역이름
    @Published var nearStNamefromUserLocation: String = ""
    @Published var isDetailPresented: Bool = false
    
    /// 호선정보
    @Published var subwayLineInfos: [SubwayLineColor] = []
    @Published var subwayLineInfosAtStation: [SubwayLineColor] = []
    
    @Published var isProgressed: Bool = false
    
    private var anyCancellable: Set<AnyCancellable> = []
    
    // 도메인 Layer
    private let useCase: MainListUseCase
    
    init(useCase: MainListUseCase) {
        // 의존성 주입: MainListVM에 MainListUseCase가 외부에서 생성되어 의존성 주입되었다.
        self.useCase = useCase
    }
    
    /// 구독메서드
    func subscribe() {
        // 해당역의 호선들의 분류작업.
        $nearStNamefromUserLocation
            .receive(on: DispatchQueue.main)
            .sink { i in
                self.isProgressed = true
                self.filteredLinesfromSelectStation(value: i)
                self.isProgressed = false
            }
            .store(in: &anyCancellable)
    }
    
    /// GPS 기반 현재위치에서 제일 가까운 역이름 가져오기
    func GPScheckNowLocactionTonearStation() {
        useCase.startFetchNearStationFromUserLocation()
    }
    
    // 도메인Layer fetchData로직(= 비즈니스 로직 -> 데이터관련 로직) 호출
    func fetchDataInfos() async {
        await useCase.dataFetchs(vm: self)
    }
}

// MARK: - Private Methods
extension MainListVM {
    private func filteredLinesfromSelectStation(value: String) {
        subwayLineInfosAtStation.removeAll() // 초기화
        
        let stationDatas = useCase.filterdLineInfosFromSelectStationName(statName: value)
        let lineData = SubwayLineColor.list // Color값 가져와야함.
        
        self.subwayLineInfosAtStation = lineData.filter({ info in
            for stationData in stationDatas where stationData.subwayId == info.subwayId {
                return true
            }
            return false
        })
        
    }
    
}

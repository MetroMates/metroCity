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
    /// 가까운 역정보
    @Published var nearStation: String = ""
    @Published var isDetailPresented: Bool = false
    
    /// 호선정보
    @Published var subwayLines = TestSubwayLineColor.tempData
    @Published var nearStationSubwayLines: [TestSubwayLineColor] = []
    
    private var anyCancellable: Set<AnyCancellable> = []
    
    // 도메인 Layer
    private let useCase: MainListUseCase
    
    init(useCase: MainListUseCase) {
        // 의존성 주입: MainListVM에 MainListUseCase가 외부에서 생성되어 의존성 주입되었다.
        self.useCase = useCase
//        self.subscribe() // 구독이 필요한 해당 View의 onAppear에 해주는게 더 좋은거 같다.
    }
    
    /// 구독메서드
    func subscribe() {
        $nearStation.sink { i in
            self.getNearStationLineInfos(value: i)
        }
        .store(in: &anyCancellable)
    }
    
    /// GPS 기반 현재위치에서 제일 가까운 역이름 가져오기
    func GPScheckNowLocactionTonearStation() {
        // GPS기반으로 제일 가까운 역을 가져오고, 만약 가져오지 못했다면
        // vm.subwayID 즉 해당 호선의 상행선기준 출발지역을 가져온다.
        self.nearStation = useCase.getNearStation()        
    }

}

extension MainListVM {
    // MARK: - Private Methods
    // 도메인Layer fetchData로직(= 비즈니스 로직 -> 데이터관련 로직) 호출
    private func fetchData(_ station: String) {
//      await useCase.fetchData(station: station)
    }
    
    private func getNearStationLineInfos(value: String) {
        nearStationSubwayLines.removeAll() // 초기화
        
        let stationDatas = useCase.getNearStationLineInfos(statName: value)
        let lineData = TestSubwayLineColor.tempData // Color값 가져와야함.
        
        self.nearStationSubwayLines = lineData.filter({ info in
            for stationData in stationDatas {
                if stationData.subwayId == info.subwayId {
                    return true
                }
            }
            return false
        })
        
    }
    
}

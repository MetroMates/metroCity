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
    
    /// 호선정보 -> View에서 사용
    @Published var subwayLineInfos: [SubwayLineColor] = []
    @Published var subwayLineInfosAtStation: [SubwayLineColor] = []
    
    @Published var isProgressed: Bool = false
    @Published var nearStationInfo: MyStation = .emptyData
    
    /// 유저 선택에 따라 역정보 popView 값을 설정하기 위한 변수
    @Published var userChoice: Bool = true
    @Published var userChoicedSubwayNm: String = ""
    
    private var stationInfos: [StationInfo] = []
    private var locationInfos: [StationLocation] = []
    
    private var anyCancellable: Set<AnyCancellable> = []
    
    // 도메인 Layer
    private let useCase: MainListUseCase
    private let startVM: StartVM
    
    init(useCase: MainListUseCase, startVM: StartVM) {
        print("👻 MainListVM")
        // 의존성 주입: MainListVM에 MainListUseCase가 외부에서 생성되어 의존성 주입되었다.
        self.useCase = useCase
        self.startVM = startVM
        startVMSubscribe()
    }
    
    deinit {
        anyCancellable.forEach { $0.cancel() }
    }
    
    /// 구독메서드
    private func subscribe(stationInfo: [StationInfo],
                           lineInfo: [SubwayLineColor],
                           locInfo: [StationLocation]) {
        
        // 해당역의 호선들의 분류작업.
        $nearStNamefromUserLocation
            .receive(on: DispatchQueue.main)
            .sink { nearStName in
                self.nearStationInfo.nowStNm = nearStName
                self.filteredLinesfromSelectStation(value: nearStName)
            }
            .store(in: &anyCancellable)
        
        print("🍜 userLocationSubscribe 진입전.")
        useCase.userLocationSubscribe(statnLocInfos: locInfo)
        print("🍜", "userLocationSubscribe 진입 후")
        
        useCase.nearStationNameSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { userLoc in
                print("🍜 nearStationNameSubject 내부@!! \(userLoc)")
                self.nearStNamefromUserLocation = userLoc
            })
            .store(in: &anyCancellable)

    }
    
    /// GPS 기반 현재위치에서 제일 가까운 역이름 가져오기
    func GPScheckNowLocactionTonearStation() {
        useCase.startFetchNearStationFromUserLocation()
    }
    
}

// MARK: - Private Methods
extension MainListVM {
    private func filteredLinesfromSelectStation(value: String) {
        subwayLineInfosAtStation.removeAll() // 초기화
        
        let stationDatas = useCase.filterdLineInfosFromSelectStationName(totalStationInfo: stationInfos,
                                                                         statName: value)
        let lineData = subwayLineInfos // Color값 가져와야함.
        
        self.subwayLineInfosAtStation = lineData.filter({ info in
            for stationData in stationDatas where stationData.subwayId == info.subwayId {
                return true
            }
            return false
        })
        
    }
    
    private func startVMSubscribe() {
        print("🍜 startVMSubscribe")
        startVM.dataPublisher()
            .receive(on: DispatchQueue.main)
            .sink { (station, line, location) in
                print("🍜 여기 진입 함. MainListVM startVMSubscribe")
                
                self.stationInfos = station
                self.subwayLineInfos = line
                self.locationInfos = location
                
                if !station.isEmpty,
                    !line.isEmpty,
                    !location.isEmpty {
                    // 초기 발행시 딱 한번 실행됨. -> 각 데이터 fetch가 완료되었을때 실행!
                    self.subscribe(stationInfo: station,
                                   lineInfo: line,
                                   locInfo: location)
                    
                    self.GPScheckNowLocactionTonearStation() // 내 위치 가져오기.
                }
                
            }
            .store(in: &anyCancellable)

    }
}

extension MainListVM {
    func checkUserChoice() {
        for lineInfo in subwayLineInfosAtStation {
            if self.userChoicedSubwayNm != lineInfo.subwayNm {
                self.userChoice = false
            }
        }
        
        if subwayLineInfosAtStation.isEmpty {
            self.userChoice = false
        }
        
        for lineInfo in subwayLineInfosAtStation {
            if self.userChoicedSubwayNm == lineInfo.subwayNm {
                self.userChoice = true
            }
        }
    }
}

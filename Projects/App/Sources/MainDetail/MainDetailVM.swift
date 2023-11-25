// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// 실시간 전철 도착 정보 ViewModel
final class MainDetailVM: ObservableObject {
    /// 검색 Text
    @Published var searchText: String = ""
    @Published var stationInfo: MyStation = .emptyData
    @Published var realTimeInfo: [RealTimeSubway] = [.emptyData]
    
    /// 상행 실시간 정보
    @Published var upRealTimeInfos: [RealTimeSubway] = [.emptyData] // 런타임 에러 방지
    /// 하행 실시간 정보
    @Published var downRealTimeInfos: [RealTimeSubway] = [.emptyData] // 런타임 에러 방지
    
    /// 근처역 관련 호선들
    @Published var nearStationLines: [TestSubwayLineColor] = []
    
    /// 호선정보 및 색상 MainListModel.swift
    var hosunInfo: TestSubwayLineColor = .emptyData
   
    // MARK: - Private Properties
    private var anyCancellable: Set<AnyCancellable> = []
    private let nearStationInfoFetchSubject = PassthroughSubject<String, Never>()
    private let lineInfoFetchSubject = PassthroughSubject<TestSubwayLineColor, Never>()
    
    private let useCase: MainDetailUseCase
    
    init(useCase: MainDetailUseCase) {
        self.useCase = useCase
    }
    
    deinit {
        anyCancellable.removeAll()
    }
    
    /// 구독 메서드
    func subscribe() {
        // 2개의 Publisher가 모두 값이 들어왔을때 실행된다. -> combineLatest, zip의 기능.
        // 아래 구문에서는 combineLatest를 사용하게 되면 처음 방출했던 이벤트를 기억하고 또 방출한다.
//        lineInfoFetchSubject.combineLatest(nearStationInfoFetchSubject)
        
        lineInfoFetchSubject.zip(nearStationInfoFetchSubject)
            .sink { (hosun, nearStation) in
                print("👍🏻Combine!!!")
                self.hosunInfo = hosun
                self.fetchInfo(value:
                                self.whenNearStationNoInfoSetCloseStation(nearStation))
            }
            .store(in: &anyCancellable)
    }
    
    func send(nearStInfo: String, lineInfo: TestSubwayLineColor) {
        print("SEND: \(nearStInfo) \(lineInfo)")
        nearStationInfoFetchSubject.send(nearStInfo)
        lineInfoFetchSubject.send(lineInfo)
    }
    
    func timer() {
        // 1초에 한번씩 실행이 되.
        // fetch를 해오는 구문이 있어 -> 10초에 한번 실행이되야해.
    }
    
}

// MARK: Private Methods
extension MainDetailVM {
    private func whenNearStationNoInfoSetCloseStation(_ stationName: String) -> String {
        var stationInfos = StationInfo.testList
        var stationData = stationName
        
        stationInfos = stationInfos.filter { $0.subwayId == hosunInfo.subwayId }
 
        if !stationInfos.contains { $0.statnNm == stationName } {
            // 선택한 라인에서 역코드가 제일 작은걸 가져온다.
            if let firstData = stationInfos.first {
                return firstData.statnNm
            }
        }
        return stationData
    }
    
    /// StationInfo Fetch 메서드
    private func fetchInfo(value: String) {
        getStationInfo(value)
        getRealTimeInfo(value)
    }
    
    /// 이전, 다음역 정보 DTO객체 생성
    private func getStationInfo(_ stationName: String) {
        self.stationInfo = useCase.getStationData(vm: self, stationName)
    }
    
    /// 실시간 지하철 위치 정보 fetch
    /// RealTime DTO객체 생성
    private func getRealTimeInfo(_ stationName: String) {
        upRealTimeInfos.removeAll() // 초기화
        downRealTimeInfos.removeAll() // 초기화

        print("🐹 \(hosunInfo.subwayId)")
        
        useCase.recievePublisher(subwayLine: "\(hosunInfo.subwayId)", whereData: stationName)
            .print("패치중 : ")
            // sink로 구독시 publisher의 타입의 에러 형태가 Never가 아닐경우에는 receiveCompelete도 무조건 작성해야함.
            .sink { result in
                switch result {
                case .finished:
                    print("패치완료")
                case .failure:
                    break
                }
            } receiveValue: { data in
                self.upRealTimeInfos = Array(data.filter { $0.updnLine == "상행" }.prefix(10))
                self.downRealTimeInfos = Array(data.filter { $0.updnLine == "하행" }.prefix(10))
            }
            .store(in: &anyCancellable)
    }
    
}

extension MainDetailVM {
    /// ArrivalTimeView에서 상하행 구분으로 사용.
    enum UpDn: String {
        case up = "상행"
        case down = "하행"
    }
}

struct MainDetailVM_Previews: PreviewProvider {
    static var previews: some View {
        // 이 부분에서 MainListRepository를 테스트용 데이터를 반환하는 class로 새로 생성하여 주입해주면 테스트용 Preview가 완성.!!
        MainDetailView(vm: MainDetailVM(useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService()))))
            .previewDisplayName("디테일")
        
        MainListView()
            .previewDisplayName("메인리스트")
        
    }
}

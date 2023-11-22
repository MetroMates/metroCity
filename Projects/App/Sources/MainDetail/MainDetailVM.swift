// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// 실시간 전철 도착 정보 ViewModel
final class MainDetailVM: ObservableObject {
    /// 검색 Text
    @Published var searchText: String = ""
    @Published var subwayID: String = ""
    @Published var stationInfo: MyStation = .emptyData
    @Published var realTimeInfo: RealTimeSubway = .init(statnNm: "")
    
    /// 호선정보 및 색상 MainListModel.swift
    var hosunInfo: TestSubwayLineColor = .emptyData
   
    // MARK: - Private Properties
    private var anyCancellable: Set<AnyCancellable> = []
    private let nearStationInfoFetchSubject = PassthroughSubject<String, Never>()
    private let lineInfoFetchSubject = PassthroughSubject<FireStoreCodable, Never>()
    
    private let useCase: MainDetailUseCase
    
    init(useCase: MainDetailUseCase) {
        self.useCase = useCase
    }
    
    /// 구독 메서드
    func subscribe() {
        // 2개의 Publisher가 모두 값이 들어왔을때 실행된다. -> combineLatest의 기능.
        lineInfoFetchSubject.combineLatest(nearStationInfoFetchSubject)
            .sink { (hosun, nearStation) in
                self.hosunInfo = hosun as? TestSubwayLineColor ?? .emptyData
//                print("housn정보, 역정보를 가지고 이전, 다음역정보(열차상태)와 이번역을 향해 오는 상하행선 전철의 실시간 위치정보를 fetch한다.")
                self.fetchInfo(value: nearStation)
            }
            .store(in: &anyCancellable)
    }
    
    func send(_ data: String) {
        nearStationInfoFetchSubject.send(data)
    }
    
    func send(_ data: FireStoreCodable) {
        lineInfoFetchSubject.send(data)
    }
    
    func timer() {
        // 1초에 한번씩 실행이 되.
        // fetch를 해오는 구문이 있어 -> 10초에 한번 실행이되야해.
    }
    
    func realTimeFetch() {
        
    }
    
}

// MARK: Private Methods
extension MainDetailVM {
    /// StationInfo Fetch 메서드
    private func fetchInfo(value: String) {
        getStationInfo(value)
        getRealTimeInfo(value)
    }
    
    /// 이전, 다음역 정보 DTO객체 생성
    private func getStationInfo(_ stationName: String) {
        self.stationInfo = useCase.getStationData(vm: self, stationName)
    }
    
    private func getRealTimeInfo(_ stationName: String) {
        print("엳ㄱ이름 : \(stationName)")
        useCase.recievePublisher(whereData: stationName)
            .print("패치중 : ")
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { data in
                self.realTimeInfo = data
            }
            .store(in: &anyCancellable)
    }
    
}

extension MainDetailVM {
    enum UpDn {
        case up, down
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

// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// 실시간 전철 도착 정보 ViewModel
final class MainDetailVM: ObservableObject {
    /// 검색 Text
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    @Published var filteredItems: [StationInfo] = []
    
    @Published var selectStationInfo: MyStation = .emptyData
    @Published var realTimeInfo: [RealTimeSubway] = [.emptyData]
    /// 상행 실시간 정보
    @Published var upRealTimeInfos: [RealTimeSubway] = [.emptyData] // 런타임 에러 방지
    /// 하행 실시간 정보
    @Published var downRealTimeInfos: [RealTimeSubway] = [.emptyData] // 런타임 에러 방지
    /// 선택된역 관련 호선들
    @Published var selectStationLineInfos: [SubwayLineColor] = []
    @Published var isLineListSheetOpen: Bool = false
        
    /// 호선정보 및 색상 MainListModel.swift -> 발행될 필요 없다.
    var hosunInfo: SubwayLineColor = .emptyData

    // MARK: - Private Properties
    private var lineInfos = [SubwayLineColor]()
    private var stationInfos = [StationInfo]()
    private var locationInfos = [StationLocation]()
    private var anyCancellable: Set<AnyCancellable> = []
    private var timerCancel: AnyCancellable = .init {} // Timer만 생성했다 제거했다를 반복하기 위함.
    private let selectStationInfoFetchSubject = PassthroughSubject<MyStation, Never>()
    private let selectedLineInfoFetchSubject = PassthroughSubject<SubwayLineColor, Never>()
    
    private let useCase: MainDetailUseCase
    private let startVM: StartVM
    
    init(useCase: MainDetailUseCase, startVM: StartVM) {
        self.useCase = useCase
        self.startVM = startVM
        startVMSubscribe()
    }
    
    deinit {
        anyCancellable.forEach { $0.cancel() }
        timerCancel.cancel()
    }
    
    /// 구독 메서드
    func subscribe() {
        // 2개의 Publisher가 모두 값이 들어왔을때 실행된다. -> combineLatest, zip의 기능.
        // 아래 구문에서는 combineLatest를 사용하게 되면 처음 방출했던 이벤트를 기억하고 또 방출한다. 그래서 zip으로 묶어준다.
//        lineInfoFetchSubject.combineLatest(nearStationInfoFetchSubject)
        
        selectedLineInfoFetchSubject.zip(selectStationInfoFetchSubject)
            .sink { (hosun, selectStation) in
                self.hosunInfo = hosun
                self.fetchInfo(selectStation)
            }
            .store(in: &anyCancellable)
        
        $searchText
            .receive(on: DispatchQueue.main)
            .sink { search in
                if !search.isEmpty {
                    self.filteredItems = self.stationInfos.filter { $0.statnNm.localizedCaseInsensitiveContains(search) }
                }
            }
            .store(in: &anyCancellable)
    }
    
    func send(selectStationInfo: MyStation, lineInfo: SubwayLineColor) {
        selectStationInfoFetchSubject.send(selectStationInfo)
        selectedLineInfoFetchSubject.send(lineInfo)
    }
    
    func changFilteredStationAndLineInfo(item: StationInfo) {
        let mystation: MyStation = .nowStNmInit(id: Int(item.statnId),
                                                name: item.statnNm)
        let line = lineInfos.filter { $0.subwayId == item.subwayId }.first ?? .emptyData
        
        self.send(selectStationInfo: mystation,
                          lineInfo: line)
    }
    
    /// 타이머 시작
    func timerStart() {
        // 10초에 한번씩 실행.
        self.timerCancel = Timer.publish(every: 3600.0, on: .main, in: .default)
                    .autoconnect()
                    .sink { _ in
                        self.send(selectStationInfo: self.selectStationInfo,
                                  lineInfo: self.hosunInfo)
                    }
        
    }
    
    /// 타이머 정지
    func timerStop() {
        timerCancel.cancel()
    }
    
}

// MARK: Private Methods
extension MainDetailVM {
    private func startVMSubscribe() {
        startVM.dataPublisher()
            .sink { (station, line, location) in
                self.stationInfos = station
                self.lineInfos = line
                self.locationInfos = location
            }
            .store(in: &anyCancellable)
    }
    
    private func whenNearStationEmptyInfoSetNearStation(_ stationName: String) -> String {
        var stationInfos = stationInfos
        let stationData = stationName
        
        stationInfos = stationInfos.filter { $0.subwayId == hosunInfo.subwayId }
 
        if !stationInfos.contains(where: { $0.statnNm == stationName }) {
            // 선택한 라인에서 역코드가 제일 작은걸 가져온다.
            if let firstData = stationInfos.first {
                return firstData.statnNm
            }
        }
        
        return stationData
    }
    
    /// 해당역에 관련된 호선라인 모음
    private func filteredLinesRelateStation(_ nowStation: String) {
        selectStationLineInfos.removeAll() // 초기화
        
        let stationDatas = useCase.getNearStationLineInfos(totalStation: stationInfos,
                                                           statName: nowStation)
        let lineData = lineInfos // Color값 가져와야함.
        
        selectStationLineInfos = lineData.filter({ info in
            for stationData in stationDatas where stationData.subwayId == info.subwayId {
                return true
            }
            return false
        })
        
    }
    
    /// StationInfo Fetch 메서드
    private func fetchInfo(_ selectStationInfo: MyStation) {
        let chgStationInfo = getStationInfo(whenNearStationEmptyInfoSetNearStation(selectStationInfo.nowStNm))
        
        self.selectStationInfo = chgStationInfo
        getRealTimeInfo(selectStationInfo: chgStationInfo)
        filteredLinesRelateStation(chgStationInfo.nowStNm)
    }
    
    /// 이전, 다음역 정보 DTO객체 생성
    private func getStationInfo(_ stationName: String) -> MyStation {
        return useCase.getStationData(subwayID: Int(hosunInfo.subwayId),
                                      totalStatInfos: stationInfos,
                                      selectStationName: stationName)
    }
    
    /// 실시간 지하철 위치 정보 fetch
    /// RealTime DTO객체 생성
    private func getRealTimeInfo(selectStationInfo: MyStation) {
        upRealTimeInfos.removeAll() // 초기화
        downRealTimeInfos.removeAll() // 초기화

        // 해당 호선번호로 filter, 역명으로 openAPI 통신.
        useCase.recievePublisher(subwayLine: "\(hosunInfo.subwayId)", stationInfo: selectStationInfo)
            // sink로 구독시 publisher의 타입의 에러 형태가 Never가 아닐경우에는 receiveCompelete도 무조건 작성해야함.
            .sink { result in
                switch result {
                case .finished:
                    print("⓶ 패치완료")
                case .failure(let error as NSError):
                    if URLError.Code(rawValue: error.code) == .notConnectedToInternet {
                        // 인터넷 끊겼을 시 알려줘야 함.
                        print("⓶ 연결끊김")
                    }
                }
            } receiveValue: { data in
 
                let newData = data.sorted { $0.stCnt < $1.stCnt }
                
                print("⓶ 데이터 갯수", newData.count)
                
                // 상행
                self.upRealTimeInfos = Array(newData.filter { $0.updnIndex == "0" }.prefix(6))
                // 하행
                self.downRealTimeInfos = Array(newData.filter { $0.updnIndex == "1" }.prefix(6))
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
        MainDetailPreviewView()
            .previewDisplayName("DETAIL")
        
        MainListPreviewView()
            .previewDisplayName("메인리스트")
        
    }
}

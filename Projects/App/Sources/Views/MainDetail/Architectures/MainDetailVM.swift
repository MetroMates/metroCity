// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// 실시간 전철 도착 정보 ViewModel
class MainDetailVM: ObservableObject {
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
    
    /// 서연추가) 선택된 호선에 대한 역정보 프로퍼티
    @Published var totalStationInfo: [StationInfo] = []
    /// 서연추가) 선택된 호선 색상 값 저장 -> 역 버튼 테두리 색상으로 활용
    @Published var selectedStationBorderColor: String = ""
    /// 서연추가) 유저가 역팝업뷰에서 역 선택하였을 때 배경 분기처리를 위한 프로퍼티
    @Published var userSelectedStation: String?
    /// 서연추가) 검색으로 변화하는 화면에서 색상 재설정을 위한 프로퍼티
    @Published var searchColor: String = ""
    
    /// 네트워크 끊겼을 경우 메세지
    @Published var networkDiedToastMessage: Toast?
    /// 북마크 추가/해제시 메세지
    @Published var bookMarkInfoToastMessage: Toast?
    
    /// 해당역 북마크 추가/해제 표시
    @Published var isBookMarked: Bool = false
    /// 역이 두개이상일경우 선택팝업 표시
    @Published var isSelectStation: Bool = false
    @Published var updownStatus: UpDn = .up
    
    /// 호선정보 및 색상 MainListModel.swift
    @Published var hosunInfo: SubwayLineColor = .emptyData
    
    // MARK: - Private Properties
    private var lineInfos = [SubwayLineColor]()
    private var stationInfos = [StationInfo]()
    private var locationInfos = [StationLocation]()
    private var relateStationInfos = [RelateStationInfo]()
    private var anyCancellable: Set<AnyCancellable> = []
    private var timerCancel: AnyCancellable = .init {} // Timer만 생성했다 제거했다를 반복하기 위함.
    private var trainTimerCancel: AnyCancellable = .init {}
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
        timerStop()
        trainTimerStop()
    }
    
    /// 선택한 역의 이전,다음역정보와 관련호선정보, 실시간 운행정보까지 세팅한다.
    func settingSubwayInfo(hosun: SubwayLineColor, selectStation: MyStation) {
        self.hosunInfo = hosun
        self.fetchInfo(selectStation)
        fetchBookMark()
    }
    
    /// 구독 메서드
    func subscribe() {
        // 2개의 Publisher가 모두 값이 들어왔을때 실행된다. -> combineLatest, zip의 기능.
        // 아래 구문에서는 combineLatest를 사용하게 되면 처음 방출했던 이벤트를 기억하고 또 방출한다. 그래서 zip으로 묶어준다.
        selectedLineInfoFetchSubject.zip(selectStationInfoFetchSubject)
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main) // 1초의 디바운스 적용.
            .sink { (hosun, selectStation) in
                self.settingSubwayInfo(hosun: hosun, selectStation: selectStation)
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
        
        // 선택된 호선 색상을 startVM쪽에 넘겨서 탭바 shadow색상 변경
        $hosunInfo
            .receive(on: DispatchQueue.main)
            .sink { lineColor in
                self.startVM.selectLineInfo = lineColor
            }
            .store(in: &anyCancellable)
    }
    
    /// (디바운스적용) 선택한 역의 이전,다음역정보와 관련호선정보, 실시간 운행정보까지 세팅한다.
    func settingSubwayInfoWithDebounce(selectStationInfo: MyStation, lineInfo: SubwayLineColor) {
        selectStationInfoFetchSubject.send(selectStationInfo)
        selectedLineInfoFetchSubject.send(lineInfo)
    }
    
    func changeFilteredStationAndLineInfo(item: StationInfo) {
        let mystation: MyStation = .nowStNmInit(id: Int(item.statnId),
                                                name: item.statnNm)
        let line = lineInfos.filter { $0.subwayId == item.subwayId }.first ?? .emptyData
        
        self.settingSubwayInfo(hosun: line, selectStation: mystation)
        
    }
    
    /// 타이머 시작
    func timerStart() {
        self.timerCancel = Timer.publish(every: gapiFetchTimeSecond, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                self.settingSubwayInfoWithDebounce(selectStationInfo: self.selectStationInfo,
                                                   lineInfo: self.hosunInfo)
            }
        
    }
    
    /// 타이머 정지
    func timerStop() {
        timerCancel.cancel()
    }
    
    func trainTimerStart(handler: @escaping () -> Void) {
        self.trainTimerCancel = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { _ in
                handler()
            })
    }
    
    func trainTimerStop() {
        trainTimerCancel.cancel()
    }
    
    func addBookMark() {
        let coreDataManager = CoreDataManger.shared
        let context = coreDataManager.newContextForBackgroundThread()
        
        let isResult = coreDataManager.create(contextValue: context) {
            let bookMarkInfo = BookMarkEntity(context: context)
            bookMarkInfo.statnId = hosunInfo.subwayId
            bookMarkInfo.statnNm = hosunInfo.subwayNm
            bookMarkInfo.subwayId = Int32(selectStationInfo.nowSt)
            bookMarkInfo.subwayNm = selectStationInfo.nowStNm
            bookMarkInfo.lineColor = hosunInfo.lineColorHexCode
        }
        
        if isResult {
            self.bookMarkInfoToastMessage = .init(style: .success, message: "즐겨찾기에 추가되었습니다.")
        }
        
        fetchBookMark()
    }
    
    func deleteBookMark() {
        let coreDataManger = CoreDataManger.shared
        let isResult = coreDataManger.delete(type: BookMarkEntity.self, column: \.subwayId, value: Int32(selectStationInfo.nowSt))
        
        if isResult {
            self.bookMarkInfoToastMessage = .init(style: .success, message: "즐겨찾기가 해제되었습니다.")
            
        }
        fetchBookMark()
    }
    
    func fetchBookMark() {
        let coreDataManger = CoreDataManger.shared
        let isResult = coreDataManger.retrieve(type: BookMarkEntity.self, column: \.subwayId, comparision: .equal, value: Int32(selectStationInfo.nowSt))
        
        isBookMarked = isResult.isEmpty ? false : true
    }
}

// MARK: Private Methods
extension MainDetailVM {
    private func startVMSubscribe() {
        startVM.dataPublisher()
            .sink { (station, line, location, relateInfo) in
                self.stationInfos = station
                self.lineInfos = line
                self.locationInfos = location
                self.relateStationInfos = relateInfo
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
                                      relateStatInfos: relateStationInfos,
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
                    break
                case .failure(let error as NSError):
                    if URLError.Code(rawValue: error.code) == .notConnectedToInternet {
                        // 인터넷 끊겼을 시 알려줘야 함.
                        Log.error("네트워크 연결끊김")
                        self.networkDiedToastMessage = .init(style: .error, message: "네트워크 상태가 불안정합니다. 네트워크 상태를 확인 후 재시도 바랍니다.")
                        
                    }
                }
            } receiveValue: { data in
                
                let newData = data.sorted { $0.stCnt < $1.stCnt }
                Log.trace("데이터 갯수: \(newData.count)")
                
                // 상행
                self.upRealTimeInfos = Array(newData.filter { $0.updnIndex == "0" }.prefix(4))
                // 하행
                self.downRealTimeInfos = Array(newData.filter { $0.updnIndex == "1" }.prefix(4))
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

extension MainDetailVM {
    func getStationTotal(subwayNm: String) {
        self.totalStationInfo = []
        for station in self.stationInfos where station.subwayNm == subwayNm {
            totalStationInfo.append(station)
        }
        self.totalStationInfo.sort { $0.statnId < $1.statnId }
    }
    
    func findStationColor(subwayNm: String) {
        for color in self.selectStationLineInfos {
            if color.subwayNm == subwayNm {
                self.searchColor = color.lineColorHexCode
            }
        }
    }
}

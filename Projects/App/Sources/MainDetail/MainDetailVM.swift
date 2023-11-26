// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// 실시간 전철 도착 정보 ViewModel
final class MainDetailVM: ObservableObject {
    /// 검색 Text
    @Published var searchText: String = ""
    @Published var subwayID: String = ""
    @Published var stationName: String = "" // 추후 GPS로 받아올 것.
    @Published var hosunInfo: TestSubwayLineColor = .init(subwayId: "",
                                                          subwayNm: "",
                                                          lineColorHexCode: "")
    
    @Published var hosunInfos: [HosunInfo] = [.emptyData]
    @Published var mystation: MyStation = .emptyData
    
    private let useCase: MainDetailUseCase
    private var anyCancellable: Set<AnyCancellable> = []
    
    private let passthroughSubject = PassthroughSubject<String, Never>()
    private let subwayIDpassSubject = PassthroughSubject<String, Never>()
    
    init(useCase: MainDetailUseCase) {
        self.useCase = useCase
    }
    
    /// 구독 메서드
    func subscribe() {
        // 처음 초기화할때는 호출할 필요가 없기때문에 passthroghtSubject로 발행.
        passthroughSubject.sink { newValue in
            print(newValue)
        }
        .store(in: &anyCancellable)
        
        // 이 부분도 처음 구독할때부터 바로 실행하지 않게 하기위해 passthrogughSubject를 활용해서 발행하기.
        subwayIDpassSubject.sink { _ in
//            self.changeHosunInfo(value: newValue)
        }
        .store(in: &anyCancellable)
    }
    
    func send(subwayID: String) {
        subwayIDpassSubject.send(subwayID)
    }
    
    func timer() {
        // 1초에 한번씩 실행이 돼.
        // fetch를 해오는 구문이 있어 -> 10초에 한번 실행이되야해.
    }
    
}

// MARK: Private Methods
extension MainDetailVM {
    /// subwayID에 대한 역정보들을 fetch해온다.
    private func fetchData() async {
        await fetchHosunInfos()
        fetchStationInfo()
    }
    
    private func fetchStationInfo() {
        if let stationInfo = useCase.fetchData(type: MyStation.self) {
            self.mystation = stationInfo
        }
    }
    
    /// 여러호선이 있는 경우 정보 Fetch해오기
    private func fetchHosunInfos() async {
        let hosuns = await useCase.fetchDatas(whereData: self.stationName)
        if hosuns.isEmpty {
//            self.hosunInfos = [self.hosunInfo]
        } else {
            self.hosunInfos = hosuns
        }
    }
    
    private func changeHosunInfo(value: String) {
//        if let subwayLineInfo = SubwayLine(rawValue: value) {
//            self.hosunInfo = .init(subwayID: value,
//                                   subwayNm: subwayLineInfo.subwayName,
//                                   hosunColor: subwayLineInfo.subwayColor,
//                                   lineColor: subwayLineInfo.subwayColor)
//        }
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

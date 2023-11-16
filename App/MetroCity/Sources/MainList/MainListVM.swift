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
    @Published var selectStation: String = ""
    @Published var isTapped: Bool = false
    /// 데이터 모델
    @Published var models: [MainListModel] = []

    private var anyCancellable: Set<AnyCancellable> = []
    // 도메인 Layer
    private let useCase: MainListUseCase
    
    init(domain: MainListUseCase) {
        // 의존성 주입: MainListVM에 MainListUseCase가 외부에서 생성되어 의존성 주입되었다.
        self.useCase = domain
//        self.buttonsSubscribe() // 구독이 필요한 해당 View의 onAppear에 해주는게 더 좋은거 같다.
    }
    
    /// 버튼 탭 구독
    func buttonsSubscribe() {
        $isTapped.sink(receiveValue: { tabbed in
            if tabbed {
                Task {
                    await self.fetchData("")
                }
                self.isTapped = false
            }
        }).store(in: &anyCancellable)
        
        $selectStation.sink { station in
            Task {
                await self.fetchData(station)
            }
        }
        .store(in: &anyCancellable)
        
    }
        
    // MARK: - Private Methods
    
    // 도메인Layer fetchData로직(= 비즈니스 로직 -> 데이터관련 로직) 호출
    private func fetchData(_ station: String) async {
        await useCase.fetchData(vm: self, station: station)
    }

}

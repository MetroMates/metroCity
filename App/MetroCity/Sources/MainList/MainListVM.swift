// Copyright © 2023 TDS. All rights reserved.23.11.09

import SwiftUI
import Combine

// View에서 이벤트가 발생 -> Presenter(ViewModel)에서 '무엇'인지 판단
// Presenter는 UseCase를 실행
// UseCase는 User와 Repository를 결합 (combine?)
// 각 Repository는 network, DB관련 Store에서 데이터 반환
// 다시 UI에 업데이트: Store -> Repository -> UseCase -> ViewModel -> View(UI)
// 두부과자인데 칼로리가 적은거.

/*
         
 */

/// 메인 리스트 ViewModel
final class MainListVM: ObservableObject {

    @Published var isTabbed: Bool = false
    @Published var models: [MainListModel] = []
    
    // api 서비스
    private let api = TrainAPIConnect(key: .train)
    private var anyCancellable: Set<AnyCancellable> = []
    private let useCase: MainListUseCase = .init()
    
    init() {
        self.buttonTabbed()
    }
    
    /// 버튼 탭
    func buttonTabbed() {
        $isTabbed.sink(receiveValue: { tabbed in
            if tabbed {
                Task {
                    await self.fetch()
                }
                self.isTabbed = false
            }
        }).store(in: &anyCancellable)
    }
    
    func fetch() async {
        await useCase.fetch(vm: self)
    }
        
    // MARK: - PRIVATE Methods

}

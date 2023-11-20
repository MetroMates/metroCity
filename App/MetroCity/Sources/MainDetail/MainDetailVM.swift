// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

/// 실시간 전철 도착 정보 ViewModel
final class MainDetailVM: ObservableObject {
    /// 검색 Text
    @Published var searchText: String = ""
//    @Published var model: MainDetailModel = .emptyData
    
    var subwayID: String
    private let useCase: MainDetailUseCase
    
    init(subwayID id: String, useCase: MainDetailUseCase) {
        self.subwayID = id
        self.useCase = useCase
        fetchData()
    }
    
    /// subwayID에 대한 역정보들을 fetch해온다.
    private func fetchData() {
//        let data = useCase.fetchData()
//        self.model = data
    }
    
}

struct MainDetailVM_Previews: PreviewProvider {
    static var previews: some View {
        // 이 부분에서 MainListRepository를 테스트용 데이터를 반환하는 class로 새로 생성하여 주입해주면 테스트용 Preview가 완성.!!
        MainDetailView(vm: MainDetailVM(subwayID: "신분당선", useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService()))))
            .previewDisplayName("디테일")
        
        MainListView()
            .previewDisplayName("메인리스트")
        
    }
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

/*
    필요한 DTO
    1. 해당호선에 대한 모든 역정보
       statnID, statnNM
    2. 해당호선 색상, 전반적인 UI의 색상

 */

/// 실시간 전철 도착 정보 ViewModel
final class MainDetailVM: ObservableObject {
    @Published var model: MainDetailModel = .emptyData
    
    private let subwayID: String
    private let useCase: MainDetailUseCase
    
    init(subwayID id: String, useCase: MainDetailUseCase) {
        self.subwayID = id
        self.useCase = useCase
        fetchData()
    }
    
    /// subwayID에 대한 역정보들을 fetch해온다.
    private func fetchData() {
        let data = useCase.fetchData()
        self.model = data
    }
    
}

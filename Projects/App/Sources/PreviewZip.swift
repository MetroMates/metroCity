// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 02:53 꿀꿀🐷

import SwiftUI

/// 프리뷰용.... MainDetailpreview
struct MainDetailPreviewView: View {
    private let startVM = StartVM(type: .test)
    
    var body: some View {
        MainDetailView(vm: MainDetailVM(useCase: MainDetailUseCase(repo: MainDetailRepository(networkService: SubwayAPIService())), startVM: startVM))
    }
}

struct MainListPreviewView: View {
    private let startVM = StartVM(type: .test)
    
    var body: some View {
        MainListView(mainVM: MainListVM(useCase: MainListUseCase(repo: MainListRepository(networkStore: SubwayAPIService())),
                                        startVM: startVM),
                     mainDetailVM: MainDetailVM(useCase: MainDetailUseCase(repo: MainDetailRepository(networkService: SubwayAPIService())), startVM: startVM))
    }
}

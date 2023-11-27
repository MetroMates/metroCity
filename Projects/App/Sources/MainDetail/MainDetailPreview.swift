// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 02:53 꿀꿀🐷

import SwiftUI

/// 프리뷰용.... MainDetailpreview
struct MainDetailPreviewView: View {
    @StateObject private var mainDetailVM = MainDetailVM(useCase: MainDetailUseCase(repo: MainDetailRepository(networkService: SubwayAPIService())))
    
    var body: some View {
        MainDetailView(vm: mainDetailVM)
    }
}


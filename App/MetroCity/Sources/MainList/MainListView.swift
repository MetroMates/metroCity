// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

/// 전체 호선 리스트 View
struct MainListView: View {
    @StateObject private var mainVM = MainListVM(domain: MainListUseCase(repo: MainListRepository(networkStore: SubwayAPIService())))
    @StateObject private var mainDetailVM = MainDetailVM(subwayID: "", useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService())))
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("호선 선택")
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(SubwayLine.allCases, id: \.rawValue) { line in
                            Button {
                                // 임시로 해둔거임. TODO: 추후 수정
                                mainDetailVM.subwayID = line.subwayName
                                mainVM.isDetailPresented = true
                            } label: {
                                MainListCellView(stationName: line.subwayName)
                            }
                            .navigationDestination(isPresented: $mainVM.isDetailPresented) {
                                MainDetailView(vm: mainDetailVM)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            mainVM.buttonsSubscribe()
        }
        
    }
    
}

struct MainListView_Preview: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}

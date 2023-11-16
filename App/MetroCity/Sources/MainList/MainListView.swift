// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

/// 전체 호선 리스트 View
struct MainListView: View {
    @StateObject var mainVM = MainListVM(domain: MainListUseCase(repo: MainListRepository(networkStore: SubwayAPIService())))
    
    // 임시
    let lists: [String] = ["서울", "금정"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("호선 선택")
                Button("가져오기") {
                    mainVM.isTapped.toggle()
                }
                ForEach(lists, id: \.self) { item in
                    Button {
                        // 각각 데이터 가져오기
                        mainVM.selectStation = item
                    } label: {
                        Text(item)
                    }
                    
                }
            }
            
            ScrollView {
                
            }
//            ScrollView(showsIndicators: false) {
//                VStack(alignment: .leading, spacing: 15) {
//                    ForEach(SubwayLine.allCases, id: \.rawValue) { line in
//                        NavigationLink {
//                            Text("해당 호선 역 라인 지도 View")
//                        } label: {
//                            MainListCellView(stationName: line.rawValue)
//                        }
//
//                    }
//                }
//                .padding()
//            }
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

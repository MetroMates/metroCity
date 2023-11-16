// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

/// 전체 호선 리스트 View
struct MainListView: View {
    @StateObject var mainVM = MainListVM(domain: MainListUseCase(repo: MainListRepository()))
    
    var body: some View {
        NavigationStack {
            
            Text("호선 선택")
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(SubwayLine.allCases, id: \.rawValue) { line in
                        NavigationLink {
                            Text("해당 호선 역 라인 지도 View")
                        } label: {
                            MainListCellView(stationName: line.rawValue)
                        }
                        
                    }
                }
                .padding()
                .onTapGesture {
                    
                }
            }
        }
        
    }

}

struct MainListView_Preview: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}

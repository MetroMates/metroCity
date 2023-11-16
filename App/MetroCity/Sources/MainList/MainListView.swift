// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

/// 전체 호선 리스트 View
struct MainListView: View {
    @StateObject var mainVM = MainListVM(domain: MainListUseCase(repo: MainListRepository()))
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                ForEach(mainVM.models) {
                    Text($0.statnNm)
                    Text($0.statnID)
                    Text($0.subwayID)
                }
                .font(.caption)
            }
            
            Button(action: {
                mainVM.isTapped.toggle()
            }, label: {
                Text("데이터 가져오기")
            })
        }
        .padding()
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

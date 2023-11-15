// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

/// 전체 호선 리스트 View
struct MainListView: View {
    @StateObject var mainVM: MainListVM = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(mainVM.models) {
                Text($0.statnNm)
            }
            
            Button(action: {
                mainVM.isTabbed.toggle()
            }, label: {
                Text("데이터 가져오기")
            })
        }
    }

}

struct MainListView_Preview: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}

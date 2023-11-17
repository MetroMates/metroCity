// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct MainDetailView: View {
    //    @StateObject var vm: MainDetailVM
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 25) {
                SearchContent
                TitleContent
                SubTitleContent
            }
            .padding(.horizontal)
            
            ArrivalTimeView()
            
            SubwayRouteMapView()
            
            Spacer()
            
        }
    }
    
}

// MARK: - UI 모듈 연산프로퍼티
extension MainDetailView {
    /// Search부분
    @ViewBuilder var SearchContent: some View {
        HStack {
            TextField(" 역이름을 검색해보세요", text: $searchText)
                .padding(7)
                .background {
                    Color.gray.opacity(0.3)
                }
            Button {
                // 검색 func
            } label: {
                Image(systemName: "magnifyingglass")
                    .tint(.primary)
            }
        }
    }
    /// Title 부분
    @ViewBuilder var TitleContent: some View {
        HStack(spacing: 50) {
            Color.red // 변수처리
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Button {
               // Sheet Open
            } label: {
                Text("신분당선(변수)")
                    .font(.largeTitle)
                    .tint(.primary)
            }
            
            Button {
                // 화살표 돌아가게 애니메이션 적용 rotation 사용하면 될듯.
            } label: {
                Image(systemName: "arrow.clockwise")
                    .tint(.primary)
            }
        }
    }
    
    /// SubTitle 부분
    @ViewBuilder var SubTitleContent: some View {
        HStack(spacing: 60) {
            Text("내가 있는 곳")
            Text("광교중앙(변수)")
            Button {
                
            } label: {
                Image(systemName: "bookmark")
                    .font(.title2)
                    .tint(.primary)
            }
        }
    }
    
}

// MARK: - UI 모듈 메서드
extension MainDetailView {
    
}

struct MainDetailView_Previews: PreviewProvider {
    static var previews: some View {
        //        MainListView()
        MainDetailView()
    }
}

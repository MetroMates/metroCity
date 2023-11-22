// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct MainDetailView: View {     
    @ObservedObject var vm: MainDetailVM
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 25) {
                SearchContent
                TitleContent
                SubTitleContent
            }
            .padding(.horizontal)
            
            ArrivalTimeView(vm: vm)
                .padding(.top, 30)
            
            SubwayRouteMapView(vm: vm)
                .padding(.top, 100)
            
            Spacer()
            
        }
        .onAppear {
            // 그렇게 가져온 역정보를 가지고 이전역과 다음역의 정보를 가져온다. -> 서버통신할 필요없이, 가져온 역ID를 -1, +1 하여 표시해주면 된다.
            // 여기서 fetch하여 가져와야만하는 데이터는 현재역을 향해서 오고 있는 열차들의 상태와 어디쯤왔는지에대한 시간표이다.
        }
    }
    
}

// MARK: - UI 모듈 연산프로퍼티
extension MainDetailView {
    /// Search부분
    @ViewBuilder var SearchContent: some View {
        HStack {
            TextField(" 역이름을 검색해보세요 \(vm.realTimeInfo.statnNm)", text: $vm.searchText)
                .padding(7)
                .background {
                    Color.gray.opacity(0.22)
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
            vm.hosunInfo.lineColor // 변수처리
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Button {
               // Sheet Open
            } label: {
                Text("\(vm.hosunInfo.subwayNm)")
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
            Text("현재 역")
            Text("\(vm.stationInfo.nowStNm)")
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
        // 이 부분에서 MainListRepository를 테스트용 데이터를 반환하는 class로 새로 생성하여 주입해주면 테스트용 Preview가 완성.!!
        MainDetailView(vm: MainDetailVM(useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService()))))
            .previewDisplayName("디테일")
        
        MainListView()
            .previewDisplayName("메인리스트")
        
    }
}

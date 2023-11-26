// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct MainDetailView: View {     
    @ObservedObject var vm: MainDetailVM
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                SearchContent
                TitleContent
                SubTitleContent
            }
            .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                ArrivalTimeView(vm: vm)
                    .padding(.top, 10)
                
                SubwayRouteMapView(vm: vm)
                    .padding(.top, 10)
                
                Spacer()
            }
        }
        .onAppear {
            // 그렇게 가져온 역정보를 가지고 이전역과 다음역의 정보를 가져온다. -> 서버통신할 필요없이, 가져온 역ID를 -1, +1 하여 표시해주면 된다. -> publisher로 처리함.
            // 여기서 fetch하여 가져와야만하는 데이터는 현재역을 향해서 오고 있는 열차들의 상태와 어디쯤왔는지에대한 시간표이다.
        }
        .refreshable {
            // 새로고침
            vm.send(nearStInfo: vm.stationInfo.nowStNm, lineInfo: vm.hosunInfo)
        }
    }
    
}

// MARK: - UI 모듈 연산프로퍼티
extension MainDetailView {
    /// Search부분
    @ViewBuilder private var SearchContent: some View {
        HStack {
            TextField("역이름을 검색해보세요", text: $vm.searchText)
                .padding(7)
                .padding(.leading, 3)
                .font(.caption)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 2)
                    
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
    @ViewBuilder private var TitleContent: some View {
        ZStack {
            Button {
                // Sheet Open
                print(vm.nearStationLines)
            
            } label: {
                HStack {
                    Text("\(vm.hosunInfo.subwayNm)")
                        .font(.title3)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                    
                }
                .foregroundStyle(Color.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .font(.title3)
                .bold()
                .tint(.primary)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(vm.hosunInfo.lineColor)
                }
            }
            
            HStack {
                Spacer()
                HStack(spacing: 15) {
                    Button {
                        // 화살표 돌아가게 애니메이션 적용 rotation 사용하면 될듯.
                        vm.send(nearStInfo: vm.stationInfo.nowStNm, lineInfo: vm.hosunInfo)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .tint(.primary)
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "bookmark")
                            .tint(.primary)
                    }
                }
            }
        }
        
    }
    
    /// SubTitle 부분 역정보
    @ViewBuilder private var SubTitleContent: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 17)
                .fill(vm.hosunInfo.lineColor)
                .frame(height: 30)
            
            HStack {
                Button {
                    vm.send(nearStInfo: vm.stationInfo.upStNm, lineInfo: vm.hosunInfo)
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.caption)
                        ScrollText(content: vm.stationInfo.upStNm)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(vm.hosunInfo.lineColor, lineWidth: 5)
                        .frame(width: 150, height: 40)
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                        }
                    
                    ScrollText(content: vm.stationInfo.nowStNm)
                        .font(.title3)
                        .padding(.horizontal, 5)
                        .foregroundColor(Color.black)
                        .bold()
                        
                }
                
                Button {
                    vm.send(nearStInfo: vm.stationInfo.downStNm, lineInfo: vm.hosunInfo)
                } label: {
                    HStack {
                        ScrollText(content: vm.stationInfo.downStNm)
                            .font(.headline)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 5)
                }
                
            }
            .foregroundStyle(Color.white)
        }
    }
    
}

// MARK: - UI 모듈 메서드
extension MainDetailView {
    
}

struct MainDetailView_Previews: PreviewProvider {
    @StateObject static var vm = MainDetailVM(useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService())))
    
    static var previews: some View {
        // 이 부분에서 MainListRepository를 테스트용 데이터를 반환하는 class로 새로 생성하여 주입해주면 테스트용 Preview가 완성.!!
        MainDetailView(vm: vm)
            .previewDisplayName("디테일")
        
        MainListView()
            .previewDisplayName("메인리스트")
        
        TabbarView()
            .previewDisplayName("탭바")
        
    }
}

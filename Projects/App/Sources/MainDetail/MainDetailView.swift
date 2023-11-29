// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct MainDetailView: View {     
    @ObservedObject var vm: MainDetailVM
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                SearchBarMain(mainDetailVM: vm)
                TitleContent
                SubTitleContent
            }
            .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                ArrivalTimeView(vm: vm)
                    .padding(.top, 10)
                
                SubwayRouteMapView(vm: vm)
                    .padding(.top, 30)
                
                Spacer()
            }
            .refreshable {
                vm.send(selectStationInfo: vm.selectStationInfo, lineInfo: vm.hosunInfo)
            }

        }
        .overlay {
            SelectStationLineInfosView(isPresented: $vm.isLineListSheetOpen, lineLists: $vm.selectStationLineInfos)
        }
        .onAppear {
            vm.timerStart()
        }
        .onDisappear { vm.timerStop() }
    }
    
}

// MARK: - UI 모듈 연산프로퍼티
extension MainDetailView {
    /// Title 부분
    @ViewBuilder private var TitleContent: some View {
        ZStack {
            Button {
                // Sheet Open
                vm.isLineListSheetOpen = true
                print(vm.selectStationLineInfos)
                print("🦁역 호선 정보")
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
                        vm.send(selectStationInfo: vm.selectStationInfo, lineInfo: vm.hosunInfo)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .tint(.primary)
                    }
                    
                    // MARK: - BookBark Button!!
                    Button {
                        print("Bookmark Button tapped!")
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
                    if vm.selectStationInfo.upStNm != "종착" {
                        vm.selectStationInfo.nowStNm = vm.selectStationInfo.upStNm
                        vm.send(selectStationInfo: vm.selectStationInfo, lineInfo: vm.hosunInfo)
                        print("이전역")
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.caption)
                        ScrollText(content: vm.selectStationInfo.upStNm)
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
                    
                    ScrollText(content: vm.selectStationInfo.nowStNm)
                        .font(.title3)
                        .padding(.horizontal, 5)
                        .foregroundColor(Color.black)
                        .bold()
                        
                }
                
                Button {
                    if vm.selectStationInfo.downStNm != "종착" {
                        vm.selectStationInfo.nowStNm = vm.selectStationInfo.downStNm
                        vm.send(selectStationInfo: vm.selectStationInfo, lineInfo: vm.hosunInfo)
                        print("다음역")
                    }
                } label: {
                    HStack {
                        ScrollText(content: vm.selectStationInfo.downStNm)
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
    
    static var previews: some View {
        // 이 부분에서 MainListRepository를 테스트용 데이터를 반환하는 class로 새로 생성하여 주입해주면 테스트용 Preview가 완성.!!
        MainDetailPreviewView()
            .previewDisplayName("디테일")
        
        MainListPreviewView()
            .previewDisplayName("메인리스트")

    }
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct MainDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var vm: MainDetailVM
    @ObservedObject var mainVM: MainListVM
    @State private var offset: CGFloat = .zero
    @State private var rotationAngle: Angle = .zero
    
    private var swipeToNext: some Gesture {
        DragGesture()
            .onChanged { value in
                self.offset = value.translation.width
                
            }
            .onEnded { _ in
                if self.offset > 50 {
                    self.confirmStationDatasAndPopSelectView(.up)
                } else if self.offset < -50 {
                    self.confirmStationDatasAndPopSelectView(.down)
                }
                self.offset = 0
            }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                // BookMarkView에서 사용하는 MainDetailView와의 분기처리
                if mainVM.isSearchShow {
                    SearchBarMainView(mainDetailVM: vm)
                }
                TitleContent
                SubTitleContent
            }
            .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                ArrivalTimeView(vm: vm)
                    .padding(.top, 10)
                
                SubwayRouteMapView(vm: vm)
                    .padding(.top, 20)
                    .gesture(swipeToNext)
                
                Spacer()
            }
            .refreshable {
                vm.settingSubwayInfoWithDebounce(selectStationInfo: vm.selectStationInfo, lineInfo: vm.hosunInfo)
            }

        }
        .toastView(toast: $vm.networkDiedToastMessage)
        .toastView(toast: $vm.bookMarkInfoToastMessage)
        .customBackButton()
        .overlay {
            SelectStationLineInfosView(mainDetailVM: vm, isPresented: $vm.isLineListSheetOpen, lineLists: $vm.selectStationLineInfos)
        }
        .overlay {
            SelectStationInfoView(mainDetailVM: vm, userChoice: $mainVM.userChoice, totalStationInfo: $vm.totalStationInfo)
        }
        .overlay { SelectStationsPop }
        .onAppear {
            vm.timerStart()
            vm.fetchBookMark()
        }
        .onDisappear { 
            vm.timerStop()
        }
        .onTapGesture {
            self.endTextEditing()
        }
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
                HStack(spacing: 20) {
                    Button {
                        // 화살표 돌아가게 애니메이션 적용 rotation 사용하면 될듯.
                        withAnimation(.easeInOut(duration: 1.5)) {
                            vm.settingSubwayInfoWithDebounce(selectStationInfo: vm.selectStationInfo, lineInfo: vm.hosunInfo)
                            rotationAngle += .degrees(360)
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .tint(.primary)
                            .rotationEffect(rotationAngle)
                    }
                    
                    // MARK: - BookBark Button!!
                    Button {
                        vm.isBookMarked ? vm.deleteBookMark() : vm.addBookMark()
                    } label: {
                        Image(systemName: vm.isBookMarked ? "bookmark.fill" : "bookmark")
                            .tint(vm.isBookMarked ? .yellow : .primary)
                    }

                }
                .font(.title2)
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
                    self.confirmStationDatasAndPopSelectView(.up)
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.caption)
                        ScrollText(content: vm.selectStationInfo.upStationName)
                            .font(.subheadline)
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
                }.onTapGesture {
                    mainVM.userChoice.toggle()
                }
                
                Button {
                    self.confirmStationDatasAndPopSelectView(.down)
                } label: {
                    HStack {
                        ScrollText(content: vm.selectStationInfo.downStationName)
                            .font(.subheadline)
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
    
    /// 표시해야할 역명이 두개이상일 경우 선택팝업
    @ViewBuilder private var SelectStationsPop: some View {
        var stationDatas: [String] {
            if vm.updownStatus == .up {
                return vm.selectStationInfo.upStNm
            }
            return vm.selectStationInfo.downStNm
        }
        
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    List(stationDatas, id: \.self) { station in
                        Text(station)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .foregroundColor(colorScheme == .dark ? Color(uiColor: .white) : Color.black)
                            .onTapGesture {
                                if vm.updownStatus == .up {
                                    self.goUpStation(station)
                                } else {
                                    self.goDownStation(station)
                                }
                                vm.isSelectStation = false
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(colorScheme == .dark ? Color(uiColor: .systemGray5) :  Color.white)
                    }
                    .listStyle(.plain)
                    .frame(height: CGFloat(stationDatas.count) * 45)
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .frame(height: CGFloat(stationDatas.count) * 45)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.blue.opacity(0.1))
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill((colorScheme == .dark ? Color(uiColor: .systemGray5) :  Color.white))
                        )
                )
                .padding(.horizontal, 100)
                .padding(.bottom, geometry.size.height * 0.4)
            }
        }
        .opacity(vm.isSelectStation ? 1.0 : 0.0)
        .onTapGesture {
            vm.isSelectStation = false
        }
    }
    
}

// MARK: - 메서드
extension MainDetailView {
    private func confirmStationDatasAndPopSelectView(_ type: MainDetailVM.UpDn) {
        if type == .up {
            if vm.selectStationInfo.upStNm.count > 1 {
                vm.updownStatus = .up
                vm.isSelectStation = true
            } else {
                self.goUpStation(vm.selectStationInfo.upStationName)
            }
        } else {
            if vm.selectStationInfo.downStNm.count > 1 {
                vm.updownStatus = .down
                vm.isSelectStation = true
            } else {
                self.goDownStation(vm.selectStationInfo.downStationName)
            }
        }
    }
    
    private func goUpStation(_ upStation: String) {
        if vm.selectStationInfo.upStationName != "종착" {
            vm.selectStationInfo.nowStNm = upStation
            vm.settingSubwayInfo(hosun: vm.hosunInfo, selectStation: vm.selectStationInfo)
        }
    }
    
    private func goDownStation(_ downStation: String) {
        if vm.selectStationInfo.downStationName != "종착" {
            vm.selectStationInfo.nowStNm = downStation
            vm.settingSubwayInfo(hosun: vm.hosunInfo, selectStation: vm.selectStationInfo)
        }
    }
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

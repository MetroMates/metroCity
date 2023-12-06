// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

/*
 MainListView.onAppear에서 mainVM.fetchData 함수 호출하기
 - mainVM.fetchData => coreData에 값이 없으면 FireStore에서 값 불러오기.
 - FireStore에서 가져온 데이터는 FireStoreCodable 프로토콜을 채택하는 DTO로 받는다.
 - FireStore fetch는 MainListRepository에서 이루어진다.
 */

/// 전체 호선 리스트 View
struct MainListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var mainVM: MainListVM
    @StateObject private var mainDetailVM: MainDetailVM
    @State private var scrollProxy: ScrollViewProxy?
    
    init(mainVM: MainListVM, mainDetailVM: MainDetailVM) {
        self._mainVM = StateObject(wrappedValue: mainVM)
        self._mainDetailVM = StateObject(wrappedValue: mainDetailVM)
    }
    
    var contentBackColor: Color {
        return colorScheme == .light ? Color.white : Color.gray.opacity(0.15)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 커스텀으로 바꾸기 프로그래뷰
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 15) {
                            if !mainVM.subwayLineInfosAtStation.isEmpty {
                                NearStationLines
                            }
                            AllStationLines
                        }
                        .padding()
                        .navigationDestination(isPresented: $mainVM.isDetailPresented) {
                            MainDetailView(vm: mainDetailVM, mainVM: mainVM)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("호선 선택")
                            .font(.title2)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            mainVM.GPScheckNowLocactionTonearStation()
                        } label: {
                            Image(systemName: "location.circle")
                                .font(.title)
                                .foregroundStyle(Color.primary.opacity(0.6))
                                .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            mainDetailVM.subscribe()
        }
        .alert("위치 권한이 필요합니다.\n설정 → 개인정보 보호 및 보안 → 위치 서비스에서 위치접근을 허용해주세요.", isPresented: $mainVM.isNoAuthToLocation) {
            Button("취소", action: {})
            Button("이동", action: { mainVM.openSetting() })
        }
        .toastView(toast: $mainVM.isNotNearStation)
    }
    
}

/// View 연산프로퍼티
extension MainListView {
    @ViewBuilder private var NearStationLines: some View {
        Section {
            VStack(spacing: 15) {
                ForEach(mainVM.subwayLineInfosAtStation) { line in
                    Button {
                        mainVM.isDetailPresented.toggle()
                        self.setLineAndstationInfo(line: line)
                        
                        // 역 선택 PopView 확인을 위함
                        mainVM.userChoicedSubwayNm = line.subwayNm
                        mainVM.checkUserChoice()
                        mainDetailVM.getStationTotal(subwayNm: line.subwayNm)
                        mainDetailVM.selectedStationBorderColor = line.lineColorHexCode
                    } label: {
                        LineCellView(stationName: line.subwayNm,
                                     stationColor: line.lineColor)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(contentBackColor)
                                .shadow(color: line.lineColor.opacity(0.4), radius: 3, x: 2, y: 1)
                        }
                    }
                    
                }
            }
            
        } header: {
            HStack(spacing: 5) {
                Image(systemName: "location.fill")
                if mainVM.isProgressed {
                    Text("주변역 검색중..")
                    ProgressView()
                } else {
                    Text("'\(mainVM.nearStNamefromUserLocation)역' 기준")
                }
            }
        }
    }
    
    @ViewBuilder private var AllStationLines: some View {
        Section {
            VStack(spacing: 15) {
                ForEach(mainVM.subwayLineInfos) { line in
                    Button {
                        self.setLineAndstationInfo(line: line)
                        mainVM.isDetailPresented.toggle()
                        
                        // 역 선택 PopView 확인을 위함
                        mainVM.userChoicedSubwayNm = line.subwayNm
                        mainVM.checkUserChoice()
                        mainDetailVM.getStationTotal(subwayNm: line.subwayNm)
                        mainDetailVM.selectedStationBorderColor = line.lineColorHexCode
                    } label: {
                        LineCellView(stationName: line.subwayNm,
                                     stationColor: line.lineColor)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(contentBackColor)
                                .shadow(color: line.lineColor.opacity(0.4), radius: 3, x: 2, y: 1)
                        }
                    }
                    
                }
            }
            
        } header: {
            Text("전체")
                .padding(.top, 30)
        }
    }
    
}

// MARK: - Private Methods
extension MainListView {
    /// 유저 맞춤 역정보데이터 mainDetailVm에도 똑같이 추가하는 함수
    private func setLineAndstationInfo(line: SubwayLineColor) {
        mainDetailVM.selectStationLineInfos = mainVM.subwayLineInfosAtStation
        
        mainDetailVM.settingSubwayInfo(hosun: line, selectStation: mainVM.nearStationInfo)
        
        //        mainDetailVM.send(selectStationInfo: mainVM.nearStationInfo,
        //                          lineInfo: line)
    }
}

struct MainListView_Preview: PreviewProvider {
    static var previews: some View {
        StartView(startVM: .init(type: .test))
        //        MainListPreviewView()
    }
}

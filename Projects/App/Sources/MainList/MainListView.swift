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
    //    @EnvironmentObject private var startVM: StartVM
    @StateObject private var mainVM: MainListVM
    @StateObject private var mainDetailVM: MainDetailVM
    
    init(mainVM: MainListVM, mainDetailVM: MainDetailVM) {
        self._mainVM = StateObject(wrappedValue: mainVM)
        self._mainDetailVM = StateObject(wrappedValue: mainDetailVM)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 커스텀으로 바꾸기 프로그래뷰
                ProgressView()
                    .opacity(mainVM.isProgressed ? 1.0 : 0.0)
                
                VStack(spacing: 30) {
                    Text("호선 선택")
                        .font(.title2)
                        .padding(.top, 18)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 15) {
                            if !mainVM.subwayLineInfosAtStation.isEmpty {
                                NearStationLines
                            }
                            AllStationLines
                        }
                        .padding()
                        .navigationDestination(isPresented: $mainVM.isDetailPresented) {
                            MainDetailView(vm: mainDetailVM)
                        }
                    }
                }
                .overlay(alignment: .topTrailing) {
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
        .onAppear {
            //            mainVM.subscribe() -> ViewModel 내부로 옮김.
            //            mainVM.GPScheckNowLocactionTonearStation() -> 데이터가 fetch된 후로 옮김. mainVM.subscribe 내부로 옮김.
            mainDetailVM.subscribe()
        }
        
    }
    
}

/// View 연산프로퍼티
extension MainListView {
    @ViewBuilder private var NearStationLines: some View {
        Section {
            VStack(spacing: 15) {
                ForEach(mainVM.subwayLineInfosAtStation) { line in
                    Button {
                        self.setLineAndstationInfo(line: line)
                        mainVM.isDetailPresented.toggle()
                    } label: {
                        LineCellView(stationName: line.subwayNm,
                                     stationColor: line.lineColor)
                        .border(Color.gray.opacity(0.5))
                    }
                    
                }
            }
            
        } header: {
            HStack(spacing: 5) {
                Image(systemName: "location.fill")
                Text("'\(mainVM.nearStNamefromUserLocation)역' 기준")
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
                    } label: {
                        LineCellView(stationName: line.subwayNm,
                                     stationColor: line.lineColor)
                        .border(Color.gray.opacity(0.5))
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
    private func setLineAndstationInfo(line: SubwayLineColor) {
        mainDetailVM.selectStationLineInfos = mainVM.subwayLineInfosAtStation
        mainDetailVM.send(selectStationInfo: mainVM.nearStationInfo,
                          lineInfo: line)
    }
}

struct MainListView_Preview: PreviewProvider {
    static var previews: some View {
        MainListPreviewView()
    }
}

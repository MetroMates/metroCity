// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

/*
    MainListView.onAppear에서 mainVM.fetchData 함수 호출하기
    - mainVM.fetchData => coreData에 값이 없으면 FireStore에서 값 불러오기.
    - FireStore에서 가져온 데이터는 FireStoreCodable 프로토콜을 채택하는 DTO로 받는다.
    - FireStore fetch는 MainListRepository에서 이루어진다.
    - FireStoreCodable 프로토콜을 채택하는 프리뷰용 목업 DTO를 하나 더 만들어준다.
 */

/// 전체 호선 리스트 View
struct MainListView: View {
    @StateObject private var mainVM = MainListVM(useCase: MainListUseCase(repo: MainListRepository(networkStore: SubwayAPIService())))
    
    @StateObject private var mainDetailVM = MainDetailVM(useCase: MainDetailUseCase(repo: MainDetailRepository(networkService: SubwayAPIService())))
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 커스텀으로 바꾸기 프로그래뷰
                ProgressView()
                    .opacity(mainVM.isProgressed ? 1.0 : 0.0)
                
                VStack(spacing: 30) {
                    Text("호선 선택")
                        .font(.title2)
                        .padding(.top, 5)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 15) {
                            if !mainVM.nearStation.isEmpty {
                                NearStationLines
                            }
                            AllStationLines
                        }
                        .padding()
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        mainVM.GPScheckNowLocactionTonearStation()
                        mainVM.nearStation = "서울"
                    } label: {
                        Image(systemName: "location.circle")
                            .font(.title)
                            .foregroundStyle(Color.primary.opacity(0.6))
                            .padding()
                            .padding(.trailing, 5)
                    }
                }
            }
        }
        .onAppear {
            mainVM.GPScheckNowLocactionTonearStation()
            mainVM.subscribe()
            mainDetailVM.subscribe()
        }
        
    }
    
}

/// View 연산프로퍼티
extension MainListView {
    @ViewBuilder private var NearStationLines: some View {
        Section {
            ForEach(mainVM.nearStationSubwayLines) { line in
                Button {
                    self.setLineAndstationInfo(line: line)
                    mainVM.isDetailPresented = true
                } label: {
                    MainListCellView(stationName: line.subwayNm,
                                     stationColor: line.lineColor)
                }
                .navigationDestination(isPresented: $mainVM.isDetailPresented) {
                    MainDetailView(vm: mainDetailVM)
                }
            }
            
        } header: {
            HStack(spacing: 0) {
                Image(systemName: "location.fill")
                Text("'\(mainVM.nearStation)역'기준 호선")
            }
        }
    }
    
    @ViewBuilder private var AllStationLines: some View {
        Section("전체 호선") {
            ForEach(mainVM.subwayLines) { line in
                Button {
                    self.setLineAndstationInfo(line: line)
                    mainVM.isDetailPresented = true
                } label: {
                    MainListCellView(stationName: line.subwayNm,
                                     stationColor: line.lineColor)
                }
                .navigationDestination(isPresented: $mainVM.isDetailPresented) {
                    MainDetailView(vm: mainDetailVM)
                }
            }
        }
    }
}

// MARK: - Private Methods
extension MainListView {
    private func setLineAndstationInfo(line: TestSubwayLineColor) {
        mainDetailVM.nearStationLines = mainVM.nearStationSubwayLines
        mainDetailVM.send(nearStInfo: mainVM.nearStation,
                          lineInfo: line)
    }
}

struct MainListView_Preview: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}

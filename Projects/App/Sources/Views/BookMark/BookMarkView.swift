// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import SwiftUI

/// 즐겨찾기 View
struct BookMarkView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var bookMarkVM: BookMarkVM
    @StateObject private var mainDetailVM: MainDetailVM
    
    init(bookMarkVM: BookMarkVM, mainDetailVM: MainDetailVM) {
        self._bookMarkVM = StateObject(wrappedValue: bookMarkVM)
        self._mainDetailVM = StateObject(wrappedValue: mainDetailVM)
    }
    
    var contentBackColor: Color {
        return colorScheme == .light ? Color.white : Color.gray.opacity(0.15)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                
                    if bookMarkVM.stationInfos.isEmpty {
                        Text("즐겨찾기 역을 추가해주세요.")
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 15) {
                                BookMarkLine
                            }
                            .padding()
                            .navigationDestination(isPresented: $bookMarkVM.isDetailPresented) {
                                MainDetailView(vm: mainDetailVM, mainVM: bookMarkVM) {
                                    bookMarkVM.fetchBookMark()
                                }
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack(spacing: 3) {
                            Text("즐겨찾기")
                                .font(.title2)
                            Image(systemName: "bookmark.fill")
                                .foregroundColor(Color.yellow)
                                .font(.body)
                        }
                    }
                }
            }
        }
        .onAppear {
            mainDetailVM.subscribe()
            bookMarkVM.fetchBookMark()
        }
        .refreshable {
            bookMarkVM.fetchBookMark()
        }
    }
    
}

/// View 연산프로퍼티
extension BookMarkView {
    
    @ViewBuilder private var BookMarkLine: some View {
        
        ForEach(bookMarkVM.groupedStationInfos, id: \.key) { subwayNm, stationInfosInSection in
            Section(header: Text("\(subwayNm)")) {
                ForEach(stationInfosInSection) { stationInfo in
                    Button {
                        self.setLineAndstationInfo(line: bookMarkVM.subwayLine(stationInfo.subwayId))
                        bookMarkVM.isDetailPresented.toggle()
                        
                        mainDetailVM.getStationTotal(subwayNm: stationInfo.subwayNm)
                        mainDetailVM.selectedStationBorderColor = bookMarkVM.subwayHexCode(stationInfo.subwayId)
                        let temp = MyStation(nowSt: Int(stationInfo.statnId), nowStNm: stationInfo.statnNm, upSt: 0, upStNm: "", downSt: 0, downStNm: "")
                        mainDetailVM.settingSubwayInfo(hosun: bookMarkVM.subwayLine(stationInfo.subwayId), selectStation: temp)
                    } label: {
                        LineCellView(stationName: stationInfo.statnNm,
                                     stationColor: bookMarkVM.subwayColor(stationInfo.subwayId))
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(contentBackColor)
                                .shadow(color: bookMarkVM.subwayColor(stationInfo.subwayId).opacity(0.4), radius: 3, x: 2, y: 1)
                        }
                    }
                }
            }
        }
    }
    
}

extension BookMarkView {
    /// 유저 맞춤 역정보데이터 mainDetailVm에도 똑같이 추가하는 함수
    private func setLineAndstationInfo(line: SubwayLineColor) {
        mainDetailVM.selectStationLineInfos = bookMarkVM.subwayLineInfosAtStation
        mainDetailVM.settingSubwayInfo(hosun: line, selectStation: bookMarkVM.nearStationInfo)
        
    }
}
struct BookMarkView_Preview: PreviewProvider {
    static var previews: some View {
        BookMarkPreviewView()
        //        MainListPreviewView()
    }
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

/// 도착예정시간 현황 View
struct ArrivalTimeView: View {
    @ObservedObject var vm: MainDetailVM
    @Environment(\.colorScheme) private var colorScheme // ViewModel에 넣어봤는데 값을 가져오지를 않음
    
    var body: some View {
        HStack(spacing: 2) {
            contentView(.up)
            contentView(.down)
        }
    }
}

// UI 모듈 Methods
extension ArrivalTimeView {
    /// 컨텐츠
    /// (상행, 하행) 구분
    @ViewBuilder func contentView(_ updn: MainDetailVM.UpDn) -> some View {
        var destiStation: String {
            updn == .up ? vm.stationInfo.upStNm : vm.stationInfo.downStNm
        }
        
        var trainDatas: [RealTimeSubway] {
            return updn == .up ? vm.upRealTimeInfos : vm.downRealTimeInfos
        }
        
        LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    trainList(title: "", trainDatas)
                        .frame(height: 150)
                }
                .font(.callout)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 3)
                .padding(.vertical, 10)
                .background {
                    colorScheme == .dark ? Color.white.opacity(0.15) : Color.gray.opacity(0.15)
                }
                
            } header: {
                Text(updn.rawValue)
                    .foregroundStyle(Color.white)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 15)
                    .padding(10)
                    .background {
                        vm.hosunInfo.lineColor
                    }
            }
            
        }
        
    }
    
    @ViewBuilder private func trainList(title: String, _ data: [RealTimeSubway]) -> some View {
        GeometryReader { geo in
            VStack(spacing: 5) {
//                Text(title)
//                    .font(.subheadline)
//
//                Rectangle()
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 1)
                
                VStack(spacing: 8) {
                    ForEach(data, id: \.id) { info in
                        HStack(spacing: 10) {
                            ScrollText(content: info.trainDestiStation)
                                .frame(width: geo.size.width * 0.4)
                                .foregroundStyle(info.trainTypeIndex != "0" ?
                                                 Color.blue :
                                                    Color.primary)
                            ScrollText(content: info.message)
                                .frame(width: geo.size.width * 0.5)
//                                .border(.blue)
                        }
                    }
                }
                
            }
            
            Spacer()
        }
    }
    
}

struct ArrivalTimeView_Previews: PreviewProvider {
    static var previews: some View {
        // 이 부분에서 MainListRepository를 테스트용 데이터를 반환하는 class로 새로 생성하여 주입해주면 테스트용 Preview가 완성.!!
        MainDetailPreviewView()
            .previewDisplayName("디테일")
        
        MainListView()
            .previewDisplayName("메인리스트")
    }
}

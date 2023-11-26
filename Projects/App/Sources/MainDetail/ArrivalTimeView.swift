// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

/// 도착예정시간 현황 View
struct ArrivalTimeView: View {
    @ObservedObject var vm: MainDetailVM
    
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
    /// (상행, 하행) 구분,
    @ViewBuilder func contentView(_ updn: MainDetailVM.UpDn) -> some View {
        var destiStation: String {
            updn == .up ? vm.stationInfo.upStNm : vm.stationInfo.downStNm
        }
        
        var trainDatas: [RealTimeSubway] {
            var timeData = updn == .up ? vm.upRealTimeInfos : vm.downRealTimeInfos
            timeData = timeData.filter({ info in
                info.sortOrder == 1
            })
            
            return timeData
        }
        
        var trainNextDatas: [RealTimeSubway] {
            var timeData = updn == .up ? vm.upRealTimeInfos : vm.downRealTimeInfos
            timeData = timeData.filter({ info in
                info.sortOrder == 2
            })
            
            return timeData
        }
        
        LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    trainList(title: "이번 열차", trainDatas)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80) // TODO: 상수로 말고 변수화 시키기.(내부Content비율로)
//                        .border(.black)
                    Divider()
                    
                    trainList(title: "다음 열차", trainNextDatas)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
//                        .border(.black)
                }
                .font(.callout)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 3)
                .padding(.vertical, 10)
                .background {
                    Color.gray.opacity(0.2)
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
        VStack(spacing: 5) {
            Text(title)
                .font(.subheadline)
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
            
            VStack(spacing: 15) {
                ForEach(data, id: \.id) { info in
                    HStack(spacing: 20) {
                        ScrollText(content: info.trainDestiStation)
                        ScrollText(content: info.message)
                    }
                    .padding(.horizontal, 10)
                }
            }
            
            Spacer()
        }
    }
    
}

struct ArrivalTimeView_Previews: PreviewProvider {
    static var previews: some View {
        // 이 부분에서 MainListRepository를 테스트용 데이터를 반환하는 class로 새로 생성하여 주입해주면 테스트용 Preview가 완성.!!
        MainDetailView(vm: MainDetailVM(useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService()))))
            .previewDisplayName("디테일")
        
        MainListView()
            .previewDisplayName("메인리스트")
    }
}

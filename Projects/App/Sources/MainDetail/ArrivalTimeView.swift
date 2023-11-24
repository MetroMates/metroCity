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
        
        var upstId: String {
            updn == .up ? "1111" : "2222"
        }
        
        var downstId: String {
            updn == .up ? "3333" : "4444"
        }
        
        var upMsg: String {
            updn == .up ? "전역 도착" : "3전역 출발"
        }
        
        // 도착 메세지? 가 시간단위로 나타내줄떄 1초에 1씩 카운트가 줄어들어야 한다.
        var downMsg: String {
            updn == .up ? "2전역 출발" : "177초 후 도착"
        }
        
        VStack {
            Text(updn.rawValue)
                .font(.title3)
            
            VStack(spacing: 20) {
                HStack {
                    Text("\(destiStation) 방면")
                }
                .tint(.primary)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background {
                    vm.hosunInfo.lineColor.opacity(0.5)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        VStack(alignment: .center) {
                            Text("이번 열차")
                            Text("(\(upstId))")
                                .font(.caption)
                        }
                        Text(upMsg)
                    }
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .center) {
                            Text("다음 열차")
                            Text("(\(downstId))")
                                .font(.caption)
                        }
                        Text(downMsg)
                    }
                    Spacer()
                }
                .padding(.horizontal, 3)
                .font(.callout)
                .frame(height: 80)
                
            }
            .background {
                Color.gray.opacity(0.2)
            }
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

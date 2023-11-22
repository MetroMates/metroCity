// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

/// 도착예정시간 현황 View
struct ArrivalTimeView: View {
    @ObservedObject var vm: MainDetailVM
    
    var body: some View {
        HStack(spacing: 3) {
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
        var upDnText: String {
            updn == .up ? "상행" : "하행"
        }
        
        var destiStation: String {
            updn == .up ? vm.stationInfo.beforeStNm : vm.stationInfo.afterStNm
        }
        
        VStack {
            Text(upDnText)
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
                    HStack {
                        Text("이번 열차 :")
                        Text("전역 도착")
                    }
                    
                    HStack {
                        Text("다음 열차 :")
                        Text("진입 중")
                    }
                    Spacer()
                }
                .padding(.horizontal, 3)
                .font(.callout)
                .frame(height: 80)
                
            }
            .background {
                Color.orange.opacity(0.1)
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

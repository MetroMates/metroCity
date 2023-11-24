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
        
        
        LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(spacing: 5) {
                        Text("이번 열차")
                            .font(.subheadline)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                        
                        ForEach(0..<3, id: \.self) { _ in
                            Text("\(upstId)행 \(upMsg)")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack(spacing: 5) {
                        Text("다음 열차")
                            .font(.subheadline)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                        
                        ForEach(0..<3, id: \.self) { _ in
                            Text(downMsg)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
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

// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct SubwayRouteMapView: View {
    @ObservedObject var vm: MainDetailVM
    
    var body: some View {
        VStack {
            updownStationText(.up)
            
            ZStack {
                StationLine
                
                GeometryReader { geo in
                    // 0.0 ~ 0.45 까지의 거리로 계산
                    ForEach([0.1, 0.2, 0.6], id: \.self) { x in
                        subway(geo: geo, .up, no: "\(x)00", x: x)
                    }
                    ForEach([0.1, 0.4, 0.6], id: \.self) { x in
                        subway(geo: geo, .down, no: "\(x)00", x: x)
                    }
                }
                .frame(height: 100)
            }
            
            updownStationText(.down)
            
        }
    }
}

extension SubwayRouteMapView {
    @ViewBuilder private var StationLine: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(vm.hosunInfo.lineColor)
                .frame(width: 3, height: 90)
            
            Rectangle()
                .fill(vm.hosunInfo.lineColor.opacity(0.8))
                .frame(maxWidth: .infinity)
                .frame(height: 35)
            
            stationCircle(vm.stationInfo.nowStNm)
            
        }
    }
}

extension SubwayRouteMapView {
    
    @ViewBuilder private func updownStationText(_ updn: MainDetailVM.UpDn) -> some View {
        var station: String {
            updn == .up ? vm.stationInfo.upStNm : vm.stationInfo.downStNm
        }
        var systemImage: String {
            updn == .up ? "arrow.left" : "arrow.right"
        }
        
        ZStack {
            HStack {
                Text(station)
                    .opacity(updn == .up ? 1 : 0)
                Spacer()
                Text(station)
                    .opacity(updn == .down ? 1 : 0)
            }
            Image(systemName: systemImage)
            
        }.padding(.horizontal, 3)
    }
    
    @ViewBuilder private func stationCircle(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(Color.black)
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(vm.hosunInfo.lineColor, lineWidth: 1.5)
                    .frame(height: 25)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    }
            }
    }
    
    /// 열차 View
    @ViewBuilder private func subway(geo: GeometryProxy,
                                     _ updn: MainDetailVM.UpDn,
                                     no: String, x: CGFloat) -> some View {
        Text(no)
            .font(.caption)
            .foregroundStyle(Color.primary)
            .padding(3)
            .background {
                RoundedRectangle(cornerRadius: 6)
//                    .stroke(vm.hosunInfo.lineColor.opacity(0.7), style: .init(lineWidth: 2, lineCap: .round, dash: [1,3], dashPhase: 2))
                    .stroke(vm.hosunInfo.lineColor.opacity(0.7), lineWidth: 2)
            }
            .offset(y: geo.size.height * (updn == .up ? 0.08 : 0.72))
        // 0.0 곱하면 맨 왼쪽, 0.9는 맨 오른쪽
            .offset(x: geo.size.width * (updn == .up ? (0.9 - x) : x))
    }
}

struct SubwayRouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainDetailView(vm: MainDetailVM(useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService()))))
            .previewDisplayName("디테일")
        
        MainListView()
            .previewDisplayName("메인리스트")
    }
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct SubwayRouteMapView: View {
    @ObservedObject var vm: MainDetailVM
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 0 ) {
            Label("상행", systemImage: "arrow.left")
                .font(.callout)
            
            ZStack {
                StationLine
                
                GeometryReader { geo in
                    SubwayAppearView(vm: vm, geo: geo, updn: .up)
                    SubwayAppearView(vm: vm, geo: geo, updn: .down)
                }
                .frame(height: 100)
            }
            
            Label("하행", systemImage: "arrow.right")
                .font(.callout)
            
        }
    }
}

extension SubwayRouteMapView {
    @ViewBuilder private var StationLine: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(vm.hosunInfo.lineColor)
                .frame(width: 3, height: 80)
            
            Rectangle()
                .fill(vm.hosunInfo.lineColor.opacity(0.8))
                .frame(maxWidth: .infinity)
                .frame(height: 20)
            
            ZStack {
                HStack {
                    stationCircle(vm.selectStationInfo.upStationName)
                    Spacer()
                    stationCircle(vm.selectStationInfo.downStationName)
                }
                stationCircle(vm.selectStationInfo.nowStNm)
            }
            .padding(.horizontal)
            
        }
    }
}

extension SubwayRouteMapView {
    @ViewBuilder private func stationCircle(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(Color.black)
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(vm.hosunInfo.lineColor, lineWidth: 3)
                    .frame(height: 25)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    }
            }
    }
    
}

struct SubwayRouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainDetailPreviewView()
            .previewDisplayName("디테일")
        
        MainListPreviewView()
            .previewDisplayName("메인리스트")
    }
}

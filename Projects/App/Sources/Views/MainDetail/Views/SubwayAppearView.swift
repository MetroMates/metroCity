// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import SwiftUI

struct SubwayAppearView: View {
    @ObservedObject var vm: MainDetailVM
    let geo: GeometryProxy
    let updn: MainDetailVM.UpDn
    
    var realTimeData: [RealTimeSubway] {
        updn == .up ? vm.upRealTimeInfos : vm.downRealTimeInfos
    }
    
    var body: some View {
        Group {
            ForEach(realTimeData, id: \.id) { info in
                // 운행중 상태인 열차는 표시하지않는다.
                if info.arvlCode != "99" {
                    SubwayShapeView(vm: vm, geo: geo, updn: updn, info: info)
                }
            }
        }
        .onAppear {
            // 추후 MainDetailVM으로 옮기고 새로운 정보 패치될때 timer cancel하고 하기
            // moveXoffSet도 마찬가지 -> .zero로 초기화하기.
//            vm.trainTimerStart {
//                withAnimation {
//                    vm.moveXoffSet += gtrainSpeed
//                }
//            }
        }
        .onDisappear {
//            vm.trainTimerStop()
        }
    }
}

struct SubwayShapeView_Previews: PreviewProvider {
    static var previews: some View {
        MainDetailPreviewView()
    }
}

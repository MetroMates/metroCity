// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import SwiftUI

struct SubwayShapeView: View {
    @ObservedObject var vm: MainDetailVM
    let geo: GeometryProxy
    let updn: MainDetailVM.UpDn
    @State private var textWidth: CGFloat = .zero
    
    var body: some View {
        var realTimeData: [RealTimeSubway] {
            updn == .up ? vm.upRealTimeInfos : vm.downRealTimeInfos
        }
        HStack {
            ForEach(realTimeData, id: \.id) { info in
                if info.arvlCode != "99" {
                    trainText(info: info)
                }
            }
        }
        .onAppear {
            // 추후 MainDetailVM으로 옮기고 새로운 정보 패치될때 timer cancel하고 하기
            // moveXoffSet도 마찬가지 -> .zero로 초기화하기.
            vm.trainTimerStart {
                withAnimation {
                    vm.moveXoffSet += gtrainSpeed
                }
            }
        }
        .onDisappear {
            vm.trainTimerStop()
        }
    }
}

extension SubwayShapeView {
    @ViewBuilder private func trainText(info: RealTimeSubway) -> some View {
        var moveX: CGFloat {
            let geoWidth = geo.size.width
            let startPositionRate = info.trainLocation
            // 테스트용
//            let startPositionRate = 0.5
            if updn == .up {
                let baseX = geoWidth * startPositionRate
                print("up BaseX : \(baseX)")
                return baseX - vm.moveXoffSet
            } else {
                let baseX = (geoWidth * (1 - startPositionRate)) - (textWidth + 5)
                print("down BaseX : \(baseX)")
                return baseX + vm.moveXoffSet
            }
        }
        
        var trainText: String {
            return info.trainDestiStation
            // ↓ Test용 데이터
//            return updn == .up ? "당고개행" : "오이도(급행)"

        }
        
        ScrollText(content: trainText,
                   moveOptn: false,
                   disabled: true) { _, textWidth in
            self.textWidth = textWidth
        }
            .font(.caption)
            .foregroundStyle(Color.white)
            .padding(3)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(vm.hosunInfo.lineColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(info.trainTypeIndex == "0" ? vm.hosunInfo.lineColor : .blue, lineWidth: 2)
                    )
            }
            .offset(y: geo.size.height * (updn == .up ? 0.12 : 0.68))
            .offset(x: moveX)
    }
}

struct SubwayShapeView_Previews: PreviewProvider {
    static var previews: some View {
        MainDetailPreviewView()
    }
}

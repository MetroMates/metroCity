// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import SwiftUI

struct SubwayShapeView: View {
    @ObservedObject var vm: MainDetailVM
    let geo: GeometryProxy
    let updn: MainDetailVM.UpDn
    let info: RealTimeSubway
    @State private var textWidth: CGFloat = .zero // 이 textWidth를 객체별로 따로 주기 위해서 SubwayShapeView를 따로 분리.
    
    var moveX: CGFloat {
        let geoWidth = geo.size.width
        let startPositionRate = info.trainLocation
        // 테스트용
//            let startPositionRate = 0.5
        if updn == .up {
            let baseX = geoWidth * startPositionRate
//            Log.trace("Up BaseX : \(baseX)")
            return baseX - vm.moveXoffSet
        } else {
            let baseX = (geoWidth * (1 - startPositionRate)) - (textWidth + 5)
//            Log.trace("Down BaseX : \(baseX)")
            return baseX + vm.moveXoffSet
        }
    }
    
    var trainText: String {
        return info.trainDestiStation
        // ↓ Test용 데이터
//            return updn == .up ? "당고개행" : "오이도(급행)"
    }
    
    var body: some View {
 
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

// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import SwiftUI

struct SubwayShapeView: View {
    @ObservedObject var vm: MainDetailVM
    let geo: GeometryProxy
    let updn: MainDetailVM.UpDn
    let info: RealTimeSubway
    @State private var textWidth: CGFloat = .zero // 이 textWidth를 객체별로 따로 주기 위해서 SubwayShapeView를 따로 분리.
    @State private var increaseValue: CGFloat = .zero
    
    @State private var timer: Timer?
  
    private var originX: CGFloat
    
    init(vm: MainDetailVM, geo: GeometryProxy, updn: MainDetailVM.UpDn, info: RealTimeSubway) {
        self.vm = vm
        self.geo = geo
        self.updn = updn
        self.info = info
        self.originX = UserDefaults.standard.double(forKey: "\(info.trainNo)")
    }
    
    private var moveX: CGFloat {
        var baseX: CGFloat
        
        if info.isChange {
            let geoWidth = geo.size.width
            let startPositionRate = info.trainLocation
            if updn == .up {
                baseX = geoWidth * startPositionRate
            } else {
                baseX = (geoWidth * (1 - startPositionRate)) - (textWidth + 5)
            }
        } 
        else {
            baseX = self.originX
        }
        
        return updn == .up ? baseX - increaseValue : baseX + increaseValue
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
            // Text의 너비를 가져온다.
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
            .onAppear {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    // gtrainSpeed도 구간별로 스피드를 다르게 줘야할듯. -> start: 0.2 middle: 0.5 end: 0.2 이런식으로!!
                    DispatchQueue.main.async {
                        var speed: CGFloat = .zero
                        switch info.arvlCaseCode {
                        case .start:
                            speed = GtrainSpeed.start
                        case .middle:
                            speed = GtrainSpeed.middle
                        case .end:
                            speed = GtrainSpeed.end
                        default:
                            speed = 0
                        }
                        
                        self.increaseValue += speed
                    }
                    // 이전 movex값을 넣어둔다.
                    UserDefaults.standard.set(self.moveX, forKey: "\(info.trainNo)")
                }
            }
            .onDisappear {
                self.timer?.invalidate()
            }
    }
    
}

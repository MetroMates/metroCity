// Copyright © 2024 TDS. All rights reserved. 2024-02-13 화 오후 02:46 꿀꿀🐷

import SwiftUI

struct StationTableListView: View {
    let hosun: String
    let statName: String
    @StateObject private var vm: StationTableListVM = .init()
    
    var body: some View {
        VStack {
            Selection
            ContentHeader
            HStack(spacing: 3) {
                Text("현재")
                Text("\(vm.currentTime)")
            }
            .foregroundColor(Color(hex: "42454A"))
            
            ScrollView {
                HStack {
                    LazyVStack(alignment: .leading) {
                        StationTimeInfoView(stationInfo: vm.upStationInfo, vm: vm)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    LazyVStack(alignment: .leading) {
                        StationTimeInfoView(stationInfo: vm.downStationInfo, vm: vm)
                    }
                    .frame(maxWidth: .infinity)
                }
                
            }
        }
        .padding()
        .onAppear {
            vm.fetchStationTableInfo(hosun: self.hosun,
                                     statName: self.statName)
            vm.selection = "DAY"
        }
    }
}

extension StationTableListView {
    private var Selection: some View {
        Picker("", selection: $vm.selection) {
            Text("평일")
                .tag("DAY")
            Text("토요일")
                .tag("SAT")
            Text("일요일/공휴일")
                .tag("END")
        }
        .pickerStyle(.segmented)
    }
    
    private var ContentHeader: some View {
        HStack {
            Text("상행")
                .frame(maxWidth: .infinity)
            Rectangle()
                .fill(Color(hex: "42454A"))
                .frame(width: 1)
            Text("하행")
                .frame(maxWidth: .infinity)
        }
        .frame(height: UIScreen.main.bounds.height * 0.02)
        .padding(.vertical, 10)
        .background(Color(hex: "F3F5F8"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct StationTimeInfoView: View {
    var stationInfo: [MetroCity.StationTableElement]
    @ObservedObject var vm: StationTableListVM
    
    var body: some View {
        ForEach(stationInfo.indices, id: \.self) { index in
            let currentElement = stationInfo[index]
            let nextIndex = index + 1 < stationInfo.count ? index + 1 : nil
            let nextElement = nextIndex != nil ? stationInfo[nextIndex ?? 0] : nil
            
            let currentTime = currentElement.arriveTime.isEmpty ? currentElement.startTime : currentElement.arriveTime
            let currentTimeComponents = currentTime.components(separatedBy: ":")
            
            let nextTime = nextElement?.arriveTime.isEmpty ?? false ? nextElement?.startTime : nextElement?.arriveTime
            let nextTimeComponents = nextTime?.components(separatedBy: ":")
            
            VStack(alignment: .leading) {
                HStack {
                    Text(currentTime)
                        .frame(maxWidth: 50)
                    Text("\(currentElement.destination)행")
                        .foregroundColor(Color(hex: "42454A"))
                    Spacer()
                }
                .padding(.vertical, 5)
                .background(vm.hourTime == currentTimeComponents.first ? Color(hex: "EAF7FD") : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                if currentTimeComponents.first != nextTimeComponents?.first {
                    Divider()
                }
            }

        }
        .font(.callout)
    }
}

#Preview {
    StationTableListView(hosun: "2", statName: "구로디지털단지")
}

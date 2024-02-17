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
            ScrollView {
                HStack {
                    LazyVStack(alignment: .leading) {
                        ForEach(vm.upStationInfo) { info in
                            HStack(spacing: 10) {
                                Text("\(info.arriveTime.isEmpty ? info.startTime : info.arriveTime)")
                                    .frame(width: 45, alignment: .leading)
                                Text("\(info.destination)")
//                                Text(info.weekAt)
                            }
                        }
                        .font(.callout)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    LazyVStack(alignment: .leading) {
                        ForEach(vm.downStationInfo) { info in
                            HStack(spacing: 10) {
                                Text("\(info.arriveTime.isEmpty ? info.startTime : info.arriveTime)")
                                    .frame(width: 45, alignment: .leading)
                                Text("\(info.destination)")
//                                Text(info.weekAt)
                            }
                        }
                        .font(.callout)
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
            Text("하행")
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    StationTableListView(hosun: "2", statName: "구로디지털단지")
}

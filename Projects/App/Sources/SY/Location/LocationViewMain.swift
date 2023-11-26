// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI
import CoreLocation
import Combine

struct LocationViewMain: View {
    @StateObject var LocationVM = LocationViewModel()

    var body: some View {
        VStack(spacing: 30) {
            
            Button {
                LocationVM.locationButtonTapped()
            } label: {
                Text("유저 위치 값 확인하기")
            }
            
            VStack {
                Text("위도 \(LocationVM.userLocation.crdntX)")
                Text("경도 \(LocationVM.userLocation.crdntY)")
            }
            
            Button {
                LocationVM.calculateDistance()
            } label: {
                VStack {
                    Text("3키로 반경이내 역은? \(LocationVM.stationName)역")
                    Text("StationInfo 기준 \(LocationVM.findStationInfoNm)역")
                }
            }
        }
        .onAppear {
            LocationVM.fetchingData()
            LocationVM.fetchingStationInfo()
        }
    }
}

struct LocationViewMain_Previews: PreviewProvider {
    static var previews: some View {
        LocationViewMain()
    }
}

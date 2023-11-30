// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI
import CoreLocation
import Combine

 struct LocationViewMain: View {
//    @StateObject var LocationVM = LocationViewModel()
    @Environment(\.dismiss) private var dismiss: DismissAction
    @State var toast: Toast?

    var body: some View {

        GeometryReader { geometry in
            VStack(spacing: 30) {
                Button {
                    toast = Toast(style: .error, message: "네트워크 상태가 불안정합니다. \n네트워크 상태를 확인 후 재시도 바랍니다.", width: geometry.size.width * 0.65)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                } label: {
                    Text("토스트뷰 테스트")
                }

    //            Button {
    //                /// stationLocation 데이터 추가
    //                if LocationVM.stationLocationCoreData.isEmpty {
    //                    LocationVM.fetchingData()
    //                    print("🥶 stationLocation 코어데이터 없음")
    //                    LocationVM.checkAddStationLocation()
    //                    print("🥶 코어데이터에 stationLocation 추가완료")
    //                } else {
    //                    print("🥶 stationLocation 코어데이터 있음 \(LocationVM.stationLocationCoreData.count)")
    //                }
    //            } label: {
    //                Text("StationLocation 데이터")
    //            }

    //            List {
    //                ForEach(LocationVM.stationLocationCoreData.prefix(5), id: \.self) { data in
    //                    VStack {
    //                        Text("\(data.crdntX)")
    //                        Text("\(data.crdntY)")
    //                        Text(data.statnNm)
    //                    }
    //                }
    //            }

    //            Button {
    //                /// stationInfo 데이터 추가
    //                if LocationVM.stationInfoCoreData.isEmpty {
    //                    LocationVM.fetchingStationInfo()
    //                    print("🥵 stationInfo 코어데이터 없음")
    //                    LocationVM.checkAddStationInfo()
    //                    print("🥵 코어데이터에 stationInfo 추가완료")
    //                } else {
    //                    print("🥵 stationInfo 코어데이터 있음 \(LocationVM.stationInfoCoreData.count)")
    //                }
    //            } label: {
    //                Text("StationInfo 데이터")
    //            }

    //            List {
    //                ForEach(LocationVM.stationInfoCoreData.prefix(5), id: \.self) { data in
    //                    VStack {
    //                        Text(data.subwayNm)
    //                        Text(data.statnNm)
    //                    }
    //                }
    //            }
            }
        }
        .onAppear {

        }
        .toastView(toast: $toast)
    }
 }

 struct LocationViewMain_Previews: PreviewProvider {
    static var previews: some View {
        LocationViewMain()
    }
 }

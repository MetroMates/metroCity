// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI

@MainActor
class LocationViewModel: ObservableObject {
    private let firestoreManager = FirebaseLocationManager.shared
    @StateObject var locationManager = LocationManager()
    
    @Published var documentsData: [StationLocation] = []
    @Published var targetStation: StationLocation?
    
    func fetchingData() {
        Task {
            do {
                let documents = try await firestoreManager.fetchStationLocations(collectionName: "StationLocation")
                print(documents)
                documentsData = documents
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func findTargetStation() {
        self.targetStation = locationManager.calculateDistance(userLocation: locationManager.userLocationInto, stationLocation: self.documentsData)
    }
}

struct LocationViewMain: View {
    @StateObject var LocationVM = LocationViewModel()
    @StateObject var locationManager = LocationManager()
    @State var targerStation: StationLocation = StationLocation(crdntX: 0, crdntY: 0, route: "", statnId: 0, statnNm: "")

    var body: some View {
        VStack(spacing: 30) {
            
            Button {
                locationManager.fetchUserLocation()
            } label: {
                Text("유저 위치값")
            }
            
            VStack {
                Text("위도 \(locationManager.userLocationInto.crdntX)")
                Text("경도 \(locationManager.userLocationInto.crdntY)")
            }
            
            Button {
                let targerStation = locationManager.calculateDistance(userLocation: locationManager.userLocationInto, stationLocation: LocationVM.documentsData)
                print(targerStation?.statnNm ?? "없음")
            } label: {
                Text("3키로 반경이내 역 찾아내기")
            }

        }
        .onAppear {
            LocationVM.fetchingData()
        }
    }
}

struct LocationViewMain_Previews: PreviewProvider {
    static var previews: some View {
        LocationViewMain()
    }
}

// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI

@MainActor
class LocationViewModel: ObservableObject {
    private let firestoreManager = FirebaseLocationManager.shared
    @Published var documentsData: [StationLocation] = []
    
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
}

struct LocationViewMain: View {
    @StateObject var LocationVM = LocationViewModel()
    @StateObject var locationManager = LocationManager()
    
    @State var closestStation: StationLocation?
    
    func findStation() {
        self.closestStation = locationManager.findClosestStation(userLocation: locationManager.userLocationInto, stationLocations: LocationVM.documentsData)
        
    }
    
    var body: some View {
        VStack {
            Text("유저 위치값")
            Text(locationManager.locationString)

            Button {
                if let findLocation = locationManager.findClosestStation(userLocation: locationManager.userLocationInto, stationLocations: LocationVM.documentsData) {
                    print("😎\(findLocation.statnNm)")
                } else {
                    print("dd")
                }
            } label: {
                Text("find!")
            }
            
            Button {
                print(locationManager.distacneArray.sorted())
                print(locationManager.stationArray)
            } label: {
                Text("거리 배열 값 확인하기")
            }

        }
        .onAppear {
            LocationVM.fetchingData()
            locationManager.fetchUserLocation()
        }
    }
}

struct LocationViewMain_Previews: PreviewProvider {
    static var previews: some View {
        LocationViewMain()
    }
}

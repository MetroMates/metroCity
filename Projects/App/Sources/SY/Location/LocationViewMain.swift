// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI

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
//    @State var minDistance: Double?
//
//    func findData() {
//        for station in LocationVM.documentsData {
//            if let distance = locationManager.calculateDistance(userLocation: locationManager.userLocationInto, targetLocation: station),
//                minDistance == nil || distance < minDistance! {
//                minDistance = distance
//                closestStation = station
//            }
//        }
//    }
    
    func findStation() {
        self.closestStation = locationManager.findClosestStation(userLocation: locationManager.userLocationInto, stationLocations: LocationVM.documentsData)
        
    }
    
    var body: some View {
        VStack {
            Button {
                LocationVM.fetchingData()
//                print(LocationVM.documentsData)
            } label: {
                Text("Fetch Button")
            }
            
            Button {
                locationManager.fetchUserLocation()
                print(locationManager.userLocationInto)
            } label: {
                Text("위치버튼")
            }
            
            Text(locationManager.locationString)
            
//            Button {
//                findData()
//
//                if let closestStation = closestStation, let minDistance = minDistance {
//                    print("Closest station is \(closestStation.statnNm) with a distance of \(minDistance) km.")
//                } else {
//                    print("Unable to determine the closest station.")
//                }
//            } label: {
//                Text("find!")
//            }

            Button {
                print(locationManager.userLocationInto)
                print(LocationVM.documentsData)
                if let findLocation = locationManager.findClosestStation(userLocation: locationManager.userLocationInto, stationLocations: LocationVM.documentsData) {
                    print("😎\(findLocation.statnNm)")
                } else {
                    print("dd")
                }
            } label: {
                Text("find!")
            }
        }
    }
}

struct LocationViewMain_Previews: PreviewProvider {
    static var previews: some View {
        LocationViewMain()
    }
}

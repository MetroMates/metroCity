// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI

class LocationViewModel: ObservableObject {
    private let firestoreManager = FirebaseLocationManager.shared
    
    func fetchingData() {
        Task {
            do {
                let documents = try await firestoreManager.fetchStationLocation(collectionName: "StationLocation")
                for (documentID, documentData) in documents {
                    print("Document ID: \(documentID), Data: \(documentData)")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

struct LocationViewMain: View {
    @StateObject var LocationVM = LocationViewModel()
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            Button {
                LocationVM.fetchingData()
            } label: {
                Text("Fetch Button")
            }
            
            Button {
                locationManager.fetchUserLocation()
            } label: {
                Text("위치버튼")
            }
            
            Text(locationManager.locationString)
        }
    }
}

struct LocationViewMain_Previews: PreviewProvider {
    static var previews: some View {
        LocationViewMain()
    }
}

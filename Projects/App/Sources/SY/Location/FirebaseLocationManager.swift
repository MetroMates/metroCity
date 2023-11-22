// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import CoreLocation

final class FirebaseLocationManager {
    static let shared = FirebaseLocationManager()
    private let db = Firestore.firestore()

    /// 위치정보 가져오는 함수
//    func fetchStationLocation(collectionName: String) async throws -> [[Any]] {
//        let collectionRef = db.collection(collectionName)
//
//        do {
//            let querySnapshot = try await collectionRef.getDocuments()
//            var allValues: [[Any]] = []
//
//            for document in querySnapshot.documents {
//                let documentDataValues = Array(document.data().values)
//                allValues.append(documentDataValues)
//            }
//            return allValues
//
//        } catch {
//            print(error.localizedDescription)
//        }
//        return [[""]]
//    }
    
    /// 위치정보 가져오는 함수
        func fetchStationLocations(collectionName: String) async throws -> [StationLocation] {
            let collectionRef = db.collection(collectionName)
            
            do {
                let querySnapshot = try await collectionRef.getDocuments()
                let allLocations = try querySnapshot.documents.compactMap { document in
                    return try document.decode(as: StationLocation.self)
                }
                
                return allLocations
                
            } catch {
                print(error.localizedDescription)
                throw error
            }
        }
}

extension QueryDocumentSnapshot {
    func decode<T: Decodable>(as type: T.Type) throws -> T {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data(), options: [])
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: jsonData)
            } catch {
                print("Error decoding document data: \(error)")
                throw error
            }
        }
}

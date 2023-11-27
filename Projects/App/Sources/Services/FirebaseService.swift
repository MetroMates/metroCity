// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import CoreLocation

final class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    /// 위치정보 가져오는 함수
    func fetchStationLocations<T: Decodable>(collectionName: String, type: T.Type) async throws -> [T] {
        let collectionRef = db.collection(collectionName)

        do {
            let querySnapshot = try await collectionRef.getDocuments()

            // 일반적인 querySnapshot.documents의 데이터 형식은 [String:Any] = [문서값:필드값]의 딕셔너리 형식이기 때문에
            // 거기서 필드값만 뽑아서 배열로 묶으려고 compactMap을 사용함
            let allLocations = try querySnapshot.documents.compactMap { document in
                // StationLocation의 형태로 디코딩하여 추가
                // 이렇게 디코딩 하기 위해서는 커스텀하게
                // 현재 [String:Any] type의 document에서 Any를 통해 Data를 뽑아와서 Decode 해줌
                return try document.decode(as: T.self)
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

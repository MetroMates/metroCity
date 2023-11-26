//// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 12:21 꿀꿀🐷
//
// import Foundation
//
// class NetworkManager {
//    
//    static let shared = NetworkManager()
//    
//    /// 역이름(searchTerm) 입력 받아서 통신 시도하기
//    func fetchSubway(searchTerm: String, searchNum: String) async throws -> Subway? {
//        // Encode the searchTerm
//        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            print("Invalid searchTerm")
//            return nil
//        }
//        let urlString = "http://swopenAPI.seoul.go.kr/api/subway/6343766d6773797032384d52686158/json/realtimeStationArrival/0/\(searchNum)/\(encodedSearchTerm)"
//
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return nil
//        }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            print("⭐️ \(data)")
//            let decodedData = try JSONDecoder().decode(Subway.self, from: data)
//
//            print("😈 \(decodedData)")
//            return decodedData
//
//        } catch {
//            print("!!!!!!! \(error.localizedDescription)")
//        }
//
//        return nil
//    }
// }

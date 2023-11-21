//// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷
//
//import SwiftUI
//
//// 지하철 데이터를 모두 모아둔다.
//final class OpenAPIInfo {
//
//    func fetchSeoulStationInfo() {
//
//    }
//
//    func fetchIncheonStationInfo() {
//
//    }
//
//    func fetchNamYangJuStationInfo() {
//
//    }
//
//}
//
//extension OpenAPIInfo {
//    /// URLSession 생성하여 받아오기
//    private func connectURL(url: String) async {
//        guard !url.isEmpty else { return }
//        
//        guard let encodedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        else {
//            debugPrint("url 인코딩 실패")
//            return
//        }
//
//        guard let convertURL = URL(string: encodedURLString)
//        else {
//            debugPrint("url [none]")
//            return
//        }
//
//        let urlSession: URLSession = .init(configuration: .default)
//        let urlRequest: URLRequest = .init(url: convertURL)
//
//        do {
//            let (data, _) =  try await urlSession.data(for: urlRequest)
//        } catch {
//            print(error.localizedDescription)
//        }
//
//    }
//
//    /// 데이터 받아오기
//    private func fetchData() {
//
//    }
//
//}

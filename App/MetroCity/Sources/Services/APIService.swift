// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import Foundation

// final class APIService {
//    private weak var delegate: APIServiceDelegate?
//
//    init(delegate: APIServiceDelegate) {
//        self.delegate = delegate
//    }
//
//    func fetchSession<Content: SubwayModeling>(type: Content.Type,
//                                               urlString: String) async -> Content? {
//        guard let delegate else { return nil }
//        guard let urlRequest = self.requestURL(urlString: urlString) else { return nil }
//
//        // url 세션을 생성한다.
//        let urlSession = URLSession(configuration: .default)
//
//        do {
//            let (data, _) = try await urlSession.data(for: urlRequest)
//
//            do {
//                let content = try JSONDecoder().decode(type, from: data)
//
//                let errStatus = content.errorMessage.status
//
//                // 상태값 200이 정상.
//                if errStatus == 200 {
//                    let errCode = content.errorMessage.code
//
//                    if Status(rawValue: errCode) != .INF000 {
//                        debugPrint(content.errorMessage.message)
//                    } else {
//                        delegate.afterUrlSession()
//                        return content  // 정상 처리됨.
//                    }
//                }
//            } catch {
//                do {
//                    let errorMsg = try JSONDecoder().decode(ErrorMessage.self, from: data)
//                    debugPrint(errorMsg.code, errorMsg.message)
//                } catch {
//                    debugPrint("json디코딩Err : ", error.localizedDescription)
//                }
//            }
//        } catch {
//            debugPrint("URL통신Err : ", error.localizedDescription)
//        }
//
//        return nil
//    }
//
//    private func requestURL(urlString: String) -> URLRequest? {
//        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        else {
//            debugPrint("url 인코딩 실패")
//            return nil
//        }
//
//        guard let url = URL(string: encodedURLString)
//        else {
//            debugPrint("url [none]")
//            return nil
//        }
//
//        // 요청할url에 대한 urlRequest객체를 생성한다.
//        let urlRequest: URLRequest = .init(url: url)
//        // urlRequest.httpMethod = "GET" // default
//
//        return urlRequest
//    }
//
// }

// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

/*
    TEST용 혹은 민근, 서연, 우진 각각의 테스트용 class가 있기 위해서는 POP가 필수..
    어떻게 구성하면 좋을까...
 
    http://swopenAPI.seoul.go.kr/api/subway/5a5670727973776a3532736472524f/json/realtimeStationArrival/ALL
    전체 역 정보 받아와서 statnNm, statnId를 struct 배열에 담고 해당 호선에 대한 데이터객체 만들어서 코어데이터로 저장 해놓기. -> realm을 사용해보거나 하기.
 
 */

import SwiftUI

/// API 연동 클래스 (key: ApiKey)
///
/// 변수명    타입    변수설명    값설명
///
/// KEY    String(필수)    인증키    OpenAPI 에서 발급된 인증키
///
/// TYPE    String(필수)    요청파일타입    xml : xml, xml파일 : xmlf, 엑셀파일 : xls, json파일 : json
///
/// SERVICE    String(필수)    서비스명    realtimeStationArrival
///
/// START_INDEX    INTEGER(필수)    요청시작위치    정수 입력 (페이징 시작번호 입니다 : 데이터 행 시작번호)
///
/// END_INDEX    INTEGER(필수)    요청종료위치    정수 입력 (페이징 끝번호 입니다 : 데이터 행 끝번호)
///
/// statnNm    STRING(필수)    지하철역명    지하철역명
final class SubwayAPIService: APIServiceDelegate {
    
    func workInUrlSession<Content>(type: Content.Type) async -> Content? where Content: SubwayModel2Server {
        guard let urlString else { return nil }
        guard let urlRequest = self.requestURL(urlString: urlString) else { return nil }
        
        // url 세션을 생성한다.
        let urlSession = URLSession(configuration: .default)
        
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            
            do {
                let content = try JSONDecoder().decode(type, from: data)
                
                let errStatus = content.errorMessage.status
                
                // 상태값 200이 정상.
                if errStatus == 200 {
                    let errCode = content.errorMessage.code
                    
                    if Status(rawValue: errCode) != .INF000 {
                        debugPrint(content.errorMessage.message)
                    } else {
                        return content  // 정상 처리됨.
                    }
                }
            } catch {
                do {
                    let errorMsg = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    debugPrint(errorMsg.code, errorMsg.message)
                } catch {
                    debugPrint("json디코딩Err : ", error.localizedDescription)
                }
            }
        } catch {
            debugPrint("URL통신Err : ", error.localizedDescription)
        }
        
        return nil
    }
    
    var apikey: String?
    var urlString: String?
    
    // MARK: 초기화 Method
    init() { }

    private func requestURL(urlString: String) -> URLRequest? {
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            debugPrint("url 인코딩 실패")
            return nil
        }
        
        guard let url = URL(string: encodedURLString)
        else {
            debugPrint("url [none]")
            return nil
        }
        
        // 요청할url에 대한 urlRequest객체를 생성한다.
        let urlRequest: URLRequest = .init(url: url)
        // urlRequest.httpMethod = "GET" // default
        
        return urlRequest
    }
    
}

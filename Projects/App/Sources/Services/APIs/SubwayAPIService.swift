// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

/*
    TEST용 혹은 민근, 서연, 우진 각각의 테스트용 class가 있기 위해서는 POP가 필수..
    어떻게 구성하면 좋을까...
 
    http://swopenAPI.seoul.go.kr/api/subway/5a5670727973776a3532736472524f/json/realtimeStationArrival/ALL
    전체 역 정보 받아와서 statnNm, statnId를 struct 배열에 담고 해당 호선에 대한 데이터객체 만들어서 코어데이터로 저장 해놓기. -> realm을 사용해보거나 하기.
 
 */

import SwiftUI
import Combine

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
    
    var apikey: String?
    var urlString: String?
    
    // MARK: 초기화 Method
    init() { }
    
    func request<Content>(type: Content.Type) -> AnyPublisher<Content, Error> where Content: SubwayModel2Server {
        guard let urlString, let urlRequest = self.requestURL(urlString: urlString) else {
            return Fail(error: StatusError.ERR100).eraseToAnyPublisher()
        }
        // TODO: 추후 앱 백그라운드 상태에서도 지속적인 Fetch가 이루어지게 만들어 주기.
        let urlsession = URLSession(configuration: .default)
        
        // 네트워크 에러같은 경우에는 URLError로 알아서 반환이 된다. Code = -1009
        return urlsession.dataTaskPublisher(for: urlRequest)
//            .print("⓶")
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw StatusError.ERR100
                }
                
                // 상태 코드가 200 - 299 이면 데이터와 응답을 반환
                if httpResponse.statusCode >= 200, httpResponse.statusCode < 300 {
                    return data
                } else {
                    // 서버문제를 throw
                    throw StatusError.ERR100
                }
            }
//            .map(\.data) // data, response 중 data 가져오기 -> (23.11.27) 대신에 tryMap을 활용하여 response.statusCode로 예외처리 작성.
            .decode(type: Content.self, decoder: JSONDecoder()) // data decoding
            .flatMap { content -> AnyPublisher<Content, Error> in
                let errStatus = content.errorMessage.status // 통신 후 한번더 체크.
                let errCode = content.errorMessage.code
                
                let errStatusCode = StatusError(rawValue: errCode)
                
                // 상태값 200이 정상.
                if errStatus == 200 {
                    if errStatusCode != .INF000 {
                        return Fail(error: errStatusCode ?? .INF200).eraseToAnyPublisher()
                    } else {
                        return Just(content)
                            .setFailureType(to: Error.self) // flatMap의 반환타입이 AnyPublisher<Content, Error>임 그래서 Error타입을 넣어주는 역할
                                                            // 만약 AnyPublisher<Content, Never>였다면 생략가능. (필요없기 때문)
                            .eraseToAnyPublisher()
                    }
                } else {
                    return Fail(error: errStatusCode ?? .ERR100).eraseToAnyPublisher()
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

    }

    private func requestURL(urlString: String) -> URLRequest? {
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            Log.error("url 인코딩 실패")
            return nil
        }
        
        guard let url = URL(string: encodedURLString)
        else {
            Log.error("URL [none]")
            return nil
        }
        
        // 요청할url에 대한 urlRequest객체를 생성한다.
        let urlRequest: URLRequest = .init(url: url)
        // urlRequest.httpMethod = "GET" // default
        
        return urlRequest
    }
    
}

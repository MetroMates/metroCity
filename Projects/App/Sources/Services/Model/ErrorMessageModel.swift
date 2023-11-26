// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import Foundation

// MARK: - ErrorMessage
struct ErrorMessage: Codable {
    let status: Int
    let code, message, link, developerMessage: String
    let total: Int
}

/// ErrorMessage.status ==> Api 전송 상태
enum StatusError: String, Error {
    case INF000 = "INFO-000"
    case ERR100 = "COMBINE_ERR"
    case INF100 = "INFO-100"
    case INF200 = "INFO-200"
    case ERR300 = "ERROR-300"
    case ERR301 = "ERROR-301"
    case ERR310 = "ERROR-310"
    case ERR331 = "ERROR-331"
    case ERR332 = "ERROR-332"
    case ERR333 = "ERROR-333"
    case ERR334 = "ERROR-334"
    case ERR335 = "ERROR-335"
    case ERR336 = "ERROR-336"
    case ERR500 = "ERROR-500"
    case ERR600 = "ERROR-600"
    case ERR601 = "ERROR-601"
}

 extension StatusError {
    var description: String {
        switch self {
        case .INF000:
            return "정상 처리되었습니다."
        case .ERR100:
            return "통신에러"
        case .INF100:
            return "인증키가 유효하지 않습니다."
        case .INF200:
            return "해당하는 데이터가 없습니다."
        case .ERR300:
            return "필수 값이 누락되어 있습니다. 요청인자를 참고 하십시오."
        case .ERR301:
            return "파일타입 값이 누락 혹은 유효하지 않습니다.요청인자 중 TYPE을 확인하십시오."
        case .ERR310:
            return "해당하는 서비스를 찾을 수 없습니다.요청인자 중 SERVICE를 확인하십시오."
        case .ERR331:
            return "요청시작위치 값을 확인하십시오. 요청인자 중 START_INDEX를 확인하십시오."
        case .ERR332:
            return "요청종료위치 값을 확인하십시오. 요청인자 중 END_INDEX를 확인하십시오."
        case .ERR333:
            return "요청위치 값의 타입이 유효하지 않습니다. 요청위치 값은 정수를 입력하세요."
        case .ERR334:
            return "요청종료위치 보다 요청시작위치가 더 큽니다. 요청시작조회건수는 정수를 입력하세요."
        case .ERR335:
            return "샘플데이터(샘플키:sample) 는 한번에 최대 5건을 넘을 수 없습니다. 요청시작위치와 요청종료위치 값은 1 ~ 5 사이만 가능합니다."
        case .ERR336:
            return "데이터요청은 한번에 최대 1000건을 넘을 수 없습니다. 요청종료위치에서 요청시작위치를 뺀 값이 1000을 넘지 않도록 수정하세요."
        case .ERR500:
            return "서버 오류입니다. 지속적으로 발생시 열린 데이터 광장으로 문의(Q&A) 바랍니다."
        case .ERR600:
            return "데이터베이스 연결 오류입니다. 지속적으로 발생시 열린 데이터 광장으로 문의(Q&A) 바랍니다."
        case .ERR601:
            return "SQL 문장 오류 입니다. 지속적으로 발생시 열린 데이터 광장으로 문의(Q&A) 바랍니다."
        }
    }
 }

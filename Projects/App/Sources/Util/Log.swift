// Copyright © 2023 TDS. All rights reserved. 2023-12-06 수 오후 02:00 꿀꿀🐷

import Foundation

class Log {
    enum Level: String {
        case trace = "🔎 TRACE"
        case debug = "✨ DEBUG"
        case info = "ℹ️ INFO"
        case warning = "⚠️ WARNING"
        case error = "🚨 ERROR"
    }
    
    static private func log(_ message: Any, level: Level, fileName: String, line: Int, funcName: String) {
    #if DEBUG
        let logMessage = "\(message)"
        let head = level.rawValue
        let filename = fileName.components(separatedBy: "/").last
        print("⌜ [\(head)] [\(filename ?? ""), \(line)행, func: \(funcName)]\n\tMsg 〉〉 \(logMessage) ⌟")
    #endif
    }
}

extension Log {
    /// 앱의 함수내에서의 세부적인 동작을 파악하고자 할때 사용.
    /// 특정 함수 내에서의 각 단계별 실행을 추적하고자 할 때 사용합니다. 변수의 값, 흐름의 특정 지점에 도달했을 때의 정보를 로깅하는 데 유용합니다.
    static func trace(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .trace, fileName: fileName, line: line, funcName: funcName)
    }
    /// 개발 중 상세한 정보값을 확일 할때 사용. ex: 변수의 값이 어떻게 변경되는지... 등등
    /// 특정 모듈이나 클래스에서 발생한 이벤트, 변수의 값, 특정 코드 블록의 실행 여부 등을 디버깅할 때 사용합니다.
    static func debug(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .debug, fileName: fileName, line: line, funcName: funcName)
    }
    /// 앱의 주요 이벤트나 상태 변경과 같은 정보를 나타낼때 사용. or 앱의 실행상태를 추적하거나 사용자에게 중요한 정보를 기록할때 사용.
    /// 사용자가 로그인했음을 로깅하거나, 중요한 액션 또는 이벤트가 발생했을 때 사용합니다. 예를 들어, 주문이 성공적으로 처리되었다는 정보를 기록하는 데 사용될 수 있습니다.
    static func info(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .info, fileName: fileName, line: line, funcName: funcName)
    }
    /// 프로그램이 정상적으로 실행되고 있지만, 주의해야할 상황이나 잠재적인 문제를 나타낼때 사용.
    /// 예상치 못한 동작이 발생했지만, 애플리케이션이 여전히 계속 실행될 수 있는 경고 상황을 로깅할 때 사용합니다. 예를 들어, 네트워크 연결이 불안정한 경우 경고를 발생시킬 수 있습니다.
    static func warning(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .warning, fileName: fileName, line: line, funcName: funcName)
    }
    /// 앱이 예상대로 동작하지 않는 상황이나 예외가 발생한 경우 사용. ex: throw 에러부분... 등등
    /// 데이터베이스 연결 실패, 파일을 찾을 수 없음 등의 오류를 기록할 때 사용됩니다.
    static func error(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .error, fileName: fileName, line: line, funcName: funcName)
    }
}

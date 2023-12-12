// Copyright © 2023 TDS. All rights reserved. 2023-12-08 금 오후 05:21 꿀꿀🐷

import Foundation

extension Date {
    static var currentDateToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let formattedDate = dateFormatter.string(from: Self.init())
        
        return formattedDate
    }
}

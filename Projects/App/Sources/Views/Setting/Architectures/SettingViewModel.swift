// Copyright © 2023 TDS. All rights reserved. 2023-12-04 월 오후 12:13 꿀꿀🐷

import SwiftUI

enum SchemeType: Int, CaseIterable {
    case system
    case light
    case dark
    
    /// 피커에 들어갈 말들
    var schemeType: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}

final class SettingViewModel: ObservableObject {
    @Published var isShowingAPI: Bool = false
    
    func openDefaultEmailApp() {
        if let emailURL = URL(string: "mailto:syss220211@gmail.com") {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            }
        }
    }
}

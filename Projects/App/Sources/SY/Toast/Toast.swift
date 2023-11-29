// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import SwiftUI

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
    
    static let sample = Toast(style: .success, message: "성공!", duration: 3, width: .infinity)
}

enum ToastStyle {
    case error
    case warning
    case success
    case info
    
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .info: return Color.blue
        case .warning: return Color.orange
        case .success: return Color.green
        }
    }
    
    var iconStyle: String {
        switch self {
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }
}

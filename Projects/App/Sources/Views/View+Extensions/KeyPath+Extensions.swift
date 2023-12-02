// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import Foundation

extension KeyPath {
    var toKeyName: String {
        guard let propertyName = self.debugDescription.split(separator: ".").last else { return "" }
        return String(propertyName)
    }
}

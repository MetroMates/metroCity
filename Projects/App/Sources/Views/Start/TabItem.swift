// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import Foundation

struct TabItem: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let image: String
    
    static let items: [Self] = [
        .init(name: "메인", image: "house"),
        .init(name: "즐겨찾기", image: "star"),
        .init(name: "설정", image: "gearshape")
    ]
}

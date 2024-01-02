// Copyright © 2023 TDS. All rights reserved. 2023-12-04 월 오후 12:13 꿀꿀🐷

import SwiftUI

struct DataList: Hashable {
    var title: String
    var link: String
}

final class UseDataInfoViewModel: ObservableObject {
    var linkList: [DataList] = [
        .init(title: "서울시 지하철 실시간 도착정보", link: "https://data.seoul.go.kr/dataList/OA-12764/F/1/datasetView.do"),
        .init(title: "오픈소스 라이센스 확인", link: "https://www.notion.so/API-7ff319d86f8c48bda8b855be6b281f31?pvs=4")
    ]
    
    @ViewBuilder
    func linkView(_ label: String, _ url: String) -> some View {
        if let url = URL(string: url) {
            Link(destination: url) {
                Text(label)
            }
        }
    }
}

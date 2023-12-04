// Copyright © 2023 TDS. All rights reserved. 2023-12-04 월 오후 12:13 꿀꿀🐷

import SwiftUI

struct DataList: Hashable {
    var title: String
    var link: String
}

final class UseDataInfoViewModel: ObservableObject {
    var linkList: [DataList] = [
        .init(title: "서울시 지하철 실시간 도착정보", link: "https://data.seoul.go.kr/dataList/OA-12764/F/1/datasetView.do"),
        .init(title: "서울시 지하철 실시간 위치정보", link: "https://data.seoul.go.kr/dataList/OA-12601/A/1/datasetView.do")
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

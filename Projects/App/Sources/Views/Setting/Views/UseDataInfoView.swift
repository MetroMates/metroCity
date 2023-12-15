// Copyright © 2023 TDS. All rights reserved. 2023-12-04 월 오후 12:13 꿀꿀🐷

import SwiftUI

struct UseDataInfoView: View {
    @StateObject var useDataInfoVC = UseDataInfoViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("활용한 API 정보")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.bottom, 2)
            Text("(터치 시 사이트로 연결)")
                .font(.system(size: 15, weight: .thin))
                .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
                .padding(.bottom, 20)
            ForEach(useDataInfoVC.linkList, id: \.self) { item in
                useDataInfoVC.linkView(item.title, item.link)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct UseDataInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UseDataInfoView()
    }
}

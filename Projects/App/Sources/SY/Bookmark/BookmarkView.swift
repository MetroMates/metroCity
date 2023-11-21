// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 12:21 꿀꿀🐷

import SwiftUI

struct BookmarkView: View {
    var body: some View {
        VStack {
            Text("즐겨찾기")
        }.frame(maxHeight: .infinity)
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}

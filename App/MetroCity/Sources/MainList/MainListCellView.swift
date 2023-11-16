// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct MainListCellView: View {
    let stationName: String
    
    var body: some View {
        HStack(spacing: 15) {
            Color.yellow
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            
            Text(stationName)
                .foregroundStyle(Color.primary)
            
            Spacer()
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .border(Color.gray.opacity(0.5))
        
    }
}

struct MainListCellView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}

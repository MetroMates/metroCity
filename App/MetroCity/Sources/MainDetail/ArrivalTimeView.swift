// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

/// 도착예정시간 현황 View
struct ArrivalTimeView: View {
    var body: some View {
        HStack(spacing: 3) {
            contentView()
            contentView()
        }
    }
}

// UI 모듈 Methods
extension ArrivalTimeView {
    /// 컨텐츠
    /// (상행, 하행) 구분,
    @ViewBuilder func contentView() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("상행역")
                Text("강남")
            }
            .tint(.primary)
            .frame(maxWidth: .infinity)
            .padding(10)
            .background {
                Color.red.opacity(0.5)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("곧 도착")
                    Text("강남행")
                    Text("1분 30초")
                }
                
                HStack {
                    Text("다음 열차")
                    Text("양재행")
                    Text("16분 30초")
                }
                Spacer()
            }
            .font(.callout)
            .frame(height: 80)
            
        }
        .background {
            Color.orange.opacity(0.1)
        }
        
    }
}

struct ArrivalTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalTimeView()
    }
}

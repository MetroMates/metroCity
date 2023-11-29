// Copyright © 2023 TDS. All rights reserved. 2023-11-28 화 오후 05:50 꿀꿀🐷

import SwiftUI

struct SelectStationLineInfosView: View {
    @Binding var isPresented: Bool
    @Binding var lineLists: [SubwayLineColor]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
            
            VStack(spacing: 10) {
                ForEach(lineLists, id: \.id) { list in
                    LineCellView(stationName: list.subwayNm,
                                     stationColor: list.lineColor)
                    .frame(maxWidth: 180)
                    .onTapGesture {
                        isPresented = false
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding()
            .padding(.top, 70)
        }
        .opacity(isPresented ? 1.0 : 0.0)
        .onTapGesture {
            isPresented = false
        }
        .onAppear {
            print("🦁 \(lineLists)")
        }
        
    }
}

struct SelectStationLineInfosView_Previews: PreviewProvider {
    static var previews: some View {
        SelectStationLineInfosView(isPresented: .constant(true), lineLists: .constant(SubwayLineColor.mockList))
    }
}

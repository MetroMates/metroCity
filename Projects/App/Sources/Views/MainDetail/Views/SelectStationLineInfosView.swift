// Copyright © 2023 TDS. All rights reserved. 2023-11-28 화 오후 05:50 꿀꿀🐷

import SwiftUI

struct SelectStationLineInfosView: View {
    @ObservedObject var mainDetailVM: MainDetailVM
    @Binding var isPresented: Bool
    @Binding var lineLists: [SubwayLineColor]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    List(lineLists) { list in
                        HStack {
                            Circle()
                                .fill(list.lineColor)
                                .frame(width: 20, height: 20)
                            Text(list.subwayNm)
                        }
                        .onTapGesture { // 선택한 호선 뽑아내기
                            mainDetailVM.send(selectStationInfo: mainDetailVM.selectStationInfo, lineInfo: list)
                        }
                    }
                    .listStyle(.plain)
                    .frame(height: CGFloat(lineLists.count) * 50)
                    
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .frame(height: CGFloat(lineLists.count) * 50)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.blue.opacity(0.1))
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.bottom, geometry.size.height * 0.4)
            }
        }
        .opacity(isPresented ? 1.0 : 0.0)
        .onTapGesture {
            isPresented = false
        }
    }
}

//struct SelectStationLineInfosView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectStationLineInfosView(isPresented: .constant(true), mainDetailVM: MainDetailVM, lineLists: .constant(SubwayLineColor.mockList))
//    }
//}

// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:20 꿀꿀🐷

import SwiftUI

struct SelectStationInfo: View {
    @ObservedObject var mainDetailVM: MainDetailVM
    @Binding var userChoice: Bool
    @Binding var totalStationInfo: [StationInfo]
    private let colums: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                VStack {
                    Text("찾고 싶은 역을 선택해주세요.")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                    ScrollView {
                        HStack {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(totalStationInfo.prefix(totalStationInfo.count / 2)) { station in
                                    ScrollText(content: station.statnNm)
//                                        .lineLimit(1)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: geometry.size.width / 2 - 15)
                                        .padding(.vertical, 10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(hex: mainDetailVM.selectedStationBorderColor), lineWidth: 0.5)
                                        )
                                        .onTapGesture {
                                            print(station)
                                            let temp = MyStation(nowSt: Int(station.statnId), nowStNm: station.statnNm, upSt: 0, upStNm: "", downSt: 0, downStNm: "")
                                            mainDetailVM.send(selectStationInfo: temp, lineInfo: mainDetailVM.hosunInfo)
                                            userChoice = true
                                        }
                                }
                            }
                            .padding(.horizontal, 3)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(totalStationInfo.suffix(totalStationInfo.count / 2)) { station in
//                                    Text(station.statnNm)
                                    ScrollText(content: station.statnNm)
//                                        .lineLimit(1)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: geometry.size.width / 2 - 15)
                                        .padding(.vertical, 10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(hex: mainDetailVM.selectedStationBorderColor), lineWidth: 0.5)
                                        )
                                        .onTapGesture {
                                            print(station)
                                            let temp = MyStation(nowSt: Int(station.statnId), nowStNm: station.statnNm, upSt: 0, upStNm: "", downSt: 0, downStNm: "")
                                            mainDetailVM.send(selectStationInfo: temp, lineInfo: mainDetailVM.hosunInfo)
                                            userChoice = true
                                        }
                                }
                            }
                            .padding(.horizontal, 3)
                        }
                    }
                }
                .foregroundColor(.primary)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
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
                .frame(height: geometry.size.height * 0.5)
            }
        }
        .opacity(userChoice ? 0.0 : 1.0)
        .onTapGesture {
            userChoice = true
        }
    }
}
//
//struct SelectStationInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectStationInfo(mainDetailVM: , userChoice: .constant(false), totalStationInfo: .constant(["테스트역"]))
//    }
//}

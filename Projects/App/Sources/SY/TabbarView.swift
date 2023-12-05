// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 12:21 꿀꿀🐷

import SwiftUI

// 추후 StartView에 로직 옮기기 -> StartView에서 TabBar생성.
struct TabbarView: View {
    @State private var selectedIndex = 0
    
    let tabBarNames = ["홈", "즐겨찾기"]
    let tabBarImages = ["house", "bookmark"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    switch selectedIndex {
                    case 0:
                        EmptyView()
//                        MainListView()
                        // MainDetailView(vm: MainDetailVM(useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService()))))
                    default:
                        EmptyView()
                    }
                }
               
                Spacer()
                
                HStack {
                    Spacer()
                    ForEach(0..<2) { num in
                        Text(tabBarNames[num])
                            .font(.system(size: 17))
                            .foregroundColor(selectedIndex == num ? Color(.black) : Color(.tertiaryLabel))
                            .frame(maxWidth: .infinity, alignment: .bottom)
                            .padding(.bottom, geometry.size.height * 0.02)
                        .frame(height: geometry.size.height * 0.01)
                        .padding(.bottom, geometry.size.height * 0.02)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedIndex = num
                                }
                        )
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, geometry.size.height * 0.035)
                .background(Color(UIColor.systemGray5))
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}

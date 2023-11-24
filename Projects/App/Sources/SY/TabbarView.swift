// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 12:21 꿀꿀🐷

import SwiftUI

struct TabbarView: View {
    @State private var selectedIndex = 0
    
    let tabBarNames = ["홈", "즐겨찾기"]
    
    var body: some View {
        VStack {
            ZStack {
                switch selectedIndex {
                case 0:
//                    DrawGeoView()
                    MainDetailView(vm: MainDetailVM(useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService()))))
                default:
                    BookmarkView()
                }
            }
            Spacer()
            
            HStack {
                ForEach(0..<2) { num in
                    VStack {
                        Text(tabBarNames[num])
                            .font(.title)
                            .foregroundColor(selectedIndex == num ? Color(.black) : Color(.tertiaryLabel))
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .padding(.top, 10)
                    }
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
            }
            .background(Color(UIColor.systemGray6))
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}

// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

struct StartView: View {
    @StateObject private var startVM: StartVM = .init(type: .real)
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $startVM.selectTabIndex) {
                // 메인 호선 현황
                MainListView(mainVM: MainListVM(useCase: MainListUseCase(repo: MainListRepository(networkStore: SubwayAPIService())), startVM: startVM),
                             mainDetailVM: MainDetailVM(useCase: MainDetailUseCase(repo: MainDetailRepository(networkService: SubwayAPIService())),
                                                        startVM: startVM))
                .tabItem {
                    EmptyView()
                }
                .tag(0)
                
                // 즐겨찾기
                FavoritesView()
                    .tabItem {
                        EmptyView()
                    }
                    .tag(1)
                
                // 설정
                SettingView()
                    .tabItem {
                        EmptyView()
                    }
                    .tag(2)
            }
            
            TabBarItem
            
        }

    }
}

extension StartView {
    @ViewBuilder private var TabBarItem: some View {
        var tabBarColor: Color {
            if colorScheme == .light {
                return Color.white
            } else {
                return Color.black.opacity(0.85)
            }
        }
        
        var shadowColor: Color {
            if colorScheme == .light {
                return Color.black
            }
            return Color.gray
        }
        
        var tabIconColor: Color {
//            let model = startVM.selectLineInfo
            
//            if model.subwayId == 0 {
                return Color.primary
//                if colorScheme == .light {
//                    return Color.gray.opacity(0.6)
//                } else {
//                    return Color.white.opacity(0.6)
//                }
//            }
            
//            return model.lineColor
        }
        
        HStack {
            ForEach(TabItem.items.indices, id: \.self) { index in
                Button {
                    startVM.selectTabIndex = index
                    
                } label: {
                    Label(TabItem.items[index].name,
                          systemImage: startVM.selectTabIndex == index ? "\(TabItem.items[index].image).fill" : TabItem.items[index].image)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                        .padding(.bottom, 15)
                        .contentShape(Rectangle())
                        .foregroundStyle(tabIconColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background {
            RoundedCorners(radius: 17, corners: [.topLeft, .topRight])
                .fill(tabBarColor)
                .shadow(color: shadowColor.opacity(0.5), radius: 3, x: 0, y: 0)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
    
}

struct StartView_Preview: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

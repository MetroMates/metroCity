// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

struct StartView: View {
    @ObservedObject var startVM: StartVM
    @AppStorage("systemTheme") private var systemTheme: Int = SchemeType.system.rawValue
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var mainVM: MainListVM
    @StateObject private var mainDetailVM: MainDetailVM
    @StateObject private var bookMarkVM: BookMarkVM
    @StateObject private var bookMarkDetailVM: BookMarkDetailVM
    
    init(startVM: StartVM) {
        self.startVM = startVM
        let mainListUseCase = MainListUseCase(repo: MainListRepository(networkStore: SubwayAPIService()))
        
        self._mainVM = StateObject(wrappedValue: MainListVM(useCase: mainListUseCase, startVM: startVM))
        self._mainDetailVM = StateObject(wrappedValue: MainDetailVM(useCase: MainDetailUseCase(repo: MainDetailRepository(networkService: SubwayAPIService())), startVM: startVM))
        self._bookMarkVM = StateObject(wrappedValue: BookMarkVM(useCase: mainListUseCase, startVM: startVM))
        self._bookMarkDetailVM = StateObject(wrappedValue: BookMarkDetailVM(useCase: MainDetailUseCase(repo: MainDetailRepository(networkService: SubwayAPIService())), startVM: startVM))
    }
  
    var selectedScheme: ColorScheme? {
        guard let theme = SchemeType(rawValue: systemTheme) else { return nil }
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $startVM.selectTabIndex) {
                // 메인 호선 현황
                Group {
                    MainListView(mainVM: mainVM,
                                 mainDetailVM: mainDetailVM)
                    
                    .tabItem {
                        EmptyView()
                    }
                    .tag(0)
                    
                    // 즐겨찾기
                    BookMarkView(bookMarkVM: bookMarkVM, bookMarkDetailVM: bookMarkDetailVM)
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
                .padding(.bottom, 65)
            }
            
            VStack(spacing: 5) {
                Admob()
                TabBarItem
            }
            
        }
        .preferredColorScheme(selectedScheme)
        
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
            return Color.primary
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
        StartView(startVM: .init(type: .test))
    }
}

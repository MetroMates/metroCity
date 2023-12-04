// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
//    @AppStorage("systemTheme") private var systemTheme: Int = SchemeType.allCases.first!.rawValue
    @StateObject var settingVC = SettingViewModel()
    
//    var selectedScheme: ColorScheme? {
//        guard let theme = SchemeType(rawValue: systemTheme) else { return nil }
//        switch theme {
//        case .light:
//            return .light
//        case .dark:
//            return .dark
//        default:
//            return nil
//        }
//    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
//                    Section("테마 설정") {
//                        HStack {
//                            Image(systemName: "paintpalette")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(.secondary)
//                                .padding(.trailing)
//
//                            Picker(selection: $systemTheme, label: Text("테마")) {
//                                ForEach(SchemeType.allCases, id: \.self) { item in
//                                    Text(item.schemeType)
//                                        .tag(item.rawValue)
//                                }
//                            }
//                        }
//                        .preferredColorScheme(selectedScheme)
//                    }
                    
                    Section("앱 정보") {
                        /// 버전정보 뷰
                        AppInfoView(settingVC: settingVC)
                        /// 문의하기 뷰
                        contactView(settingVC: settingVC)
                        /// 활용한 데이터 소개 뷰
                        UseDataView(settingVC: settingVC)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("설정")
                        .font(.title2)
                }
            }
        }
    }
}

struct AppInfoView: View {
    @ObservedObject var settingVC: SettingViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundColor(.secondary)
                .padding(.trailing)
            
            Text("버전정보")
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("1.0")
                .foregroundColor(.primary)
        }
    }
}

struct contactView: View {
    @ObservedObject var settingVC: SettingViewModel
    
    var body: some View {
        Button {
            settingVC.openDefaultEmailApp()
        } label: {
            HStack {
                Image(systemName: "envelope")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundColor(.secondary)
                    .padding(.trailing)
                
                Text("문의하기")
                    .foregroundColor(.primary)
                
                Spacer()
            }
        }
    }
}

struct UseDataView: View {
    @ObservedObject var settingVC: SettingViewModel
    
    var body: some View {
        Button {
            settingVC.isShowingAPI.toggle()
        } label: {
            HStack {
                Image(systemName: "doc")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundColor(.secondary)
                    .padding(.trailing)
                
                Text("활용 API")
                    .foregroundColor(.primary)
            }
        }
        .sheet(isPresented: $settingVC.isShowingAPI) {
            UseDataInfoView()
                .presentationDetents([.fraction(0.25)])
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

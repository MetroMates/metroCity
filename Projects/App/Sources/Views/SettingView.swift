// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import SwiftUI

enum SchemeType: Int, CaseIterable {
    case system
    case light
    case dark
    
    /// 피커에 들어갈 말들
    var schemeType: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("systemTheme") private var systemTheme: Int = SchemeType.allCases.first!.rawValue
    
    @State var isShowingAppInfo: Bool = false
    @State var isShowingContact: Bool = false
    
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
    
        List {
            Section("앱 설정") {
                HStack {
                    Image(systemName: "paintpalette")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                    
                    Picker(selection: $systemTheme, label: Text("테마")) {
                        ForEach(SchemeType.allCases, id: \.self) { item in
                            Text(item.schemeType)
                                .tag(item.rawValue)
                        }
                    }
                }
                .preferredColorScheme(selectedScheme)
            }
            
            Section("앱 정보") {
                Button {
                    isShowingAppInfo.toggle()
                } label: {
                    HStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                        
                        Text("앱 정보")
                            .foregroundColor(.primary)
                    }
                }
                
                Button {
                    isShowingContact.toggle()
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
            .sheet(isPresented: $isShowingAppInfo) {
                Text("앱 정보 들어갈 뷰")
                    .presentationDetents([.medium, .fraction(0.75)])
            }
            .sheet(isPresented: $isShowingContact) {
                Text("문의하기 정보 들어갈 뷰")
                    .presentationDetents([.medium, .fraction(0.75)])
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

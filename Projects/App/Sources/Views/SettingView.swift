// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import SwiftUI

enum SchemeType: Int, CaseIterable {
    case system
    case light
    case dark
    
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
    @Environment(\.colorScheme) var currentColorScheme
    @AppStorage("appTheme") private var selectedTheme: Int = SchemeType.system.rawValue
    
    var body: some View {
        HStack {
            Image(systemName: "circle.lefthalf.filled")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.secondary)
                .padding(.trailing)
            
            Picker(selection: $selectedTheme, label: Text("테마")) {
                ForEach(SchemeType.allCases, id: \.self) { item in
                    Text(item.schemeType)
                        .tag(item.rawValue)
                }
            }
//            .onChange(of: selectedTheme) { _ in
//                applyTheme()
//            }
        }
//        .onAppear {
//            applyTheme()
//        }
    }
    
//    private func applyTheme() {
//        switch SchemeType(rawValue: selectedTheme) {
//        case .system:
//            // Use the system's color scheme
//            break
//        case .light:
//            // Force light mode
//            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
//        case .dark:
//            // Force dark mode
//            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
//        case .none:
//            break
//        }
//    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

// Copyright © 2023 TDS. All rights reserved. 2023-12-15 금 오후 05:17 꿀꿀🐷

import SwiftUI

struct System {
    /// 현재 버전 정보
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    /// 우리 앱 앱스토어 링크
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/6474415798"
    
    /// 앱 스토어 최신 정보 확인
    func latestVersion() async -> String? {
        do {
            let appleID = 6474415798
            guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)") else {
                return nil
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let results = json?["results"] as? [[String: Any]]
            let appStoreVersion = results?[0]["version"] as? String
            
            return appStoreVersion
        } catch {
            print("Error fetching data: \(error)")
            return nil
        }
    }
    
    // 앱 스토어로 이동 -> urlStr 에 appStoreOpenUrlString 넣으면 이동
    func openAppStore() async {
        guard let url = URL(string: System.appStoreOpenUrlString) else { return }
        if await UIApplication.shared.canOpenURL(url) {
            await UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

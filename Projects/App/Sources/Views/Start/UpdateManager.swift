// Copyright © 2023 TDS. All rights reserved. 2023-12-18 월 오전 01:02 꿀꿀🐷

import UIKit

final class System {
    static let shared: System = .init()
    
    /// 우리 앱 앱스토어 링크
    private let appStoreOpenUrlString: String
    private let appleID: String
    /// 현재 앱버전 정보
    let appVersion: String
    /// 앱스토어에서의 앱버전 정보
    var appStoreVersion: String
    
    private init() {
        self.appleID = Bundle.main.object(forInfoDictionaryKey: "APPSTORE_ID") as? String ?? ""
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1"
        self.appStoreVersion = "1"
        self.appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(self.appleID)"
        Task {
            self.appStoreVersion = await self.latestVersion()
        }
    }
    
    /// 앱 스토어 최신 정보 확인
    private func latestVersion() async -> String {
        do {
            guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)") else {
                return "1"
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let results = json?["results"] as? [[String: Any]]
            let appStoreVersion = results?[0]["version"] as? String
            
            return appStoreVersion ?? "1"
        } catch {
            Log.error("Error fetching data: \(error)")
            return "1"
        }
    }
    
    // 앱 스토어로 이동 -> urlStr 에 appStoreOpenUrlString 넣으면 이동
    func openAppStore() async {
        guard let url = URL(string: self.appStoreOpenUrlString) else { return }
        if await UIApplication.shared.canOpenURL(url) {
            await UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

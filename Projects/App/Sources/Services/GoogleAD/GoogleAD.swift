// Copyright © 2023 TDS. All rights reserved. 2023-12-14 목 오후 09:30 꿀꿀🐷

import SwiftUI
import GoogleMobileAds

struct GADBanner: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        let api = Bundle.main.object(forInfoDictionaryKey: "GAD_BANNER_ID")
        view.adUnitID = api as? String ?? ""
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}

@ViewBuilder func Admob() -> some View {
    // admob
    GADBanner()
        .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
}

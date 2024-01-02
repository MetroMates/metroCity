// Copyright © 2023 TDS. All rights reserved. 2023-12-14 목 오후 09:30 꿀꿀🐷

import SwiftUI
import GoogleMobileAds

struct GADBanner: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        let api = Bundle.main.object(forInfoDictionaryKey: "GAD_BANNER_ID")
        bannerView.adUnitID = api as? String ?? ""
        bannerView.rootViewController = viewController
        viewController.view.addSubview(bannerView)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        bannerView.delegate = context.coordinator
        bannerView.load(GADRequest())
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class GADBannerCoordinator: NSObject, GADBannerViewDelegate {
//        var parent: GADBanner
//        
//        init(_ parent: GADBanner) {
//            self.parent = parent
//        }
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            Log.info("배너광고 Load 완료.")
        }
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            Log.warning("배너광고 Load 실패. \(error.localizedDescription)")
        }
        func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
            Log.info("배너광고 Click됨.")
        }
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            Log.info("배너광고 백그라운드 상태")
        }
        
    }
    
    func makeCoordinator() -> GADBannerCoordinator {
        GADBannerCoordinator()
    }
}

@ViewBuilder func Admob() -> some View {
    // admob
    GADBanner()
        .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
}

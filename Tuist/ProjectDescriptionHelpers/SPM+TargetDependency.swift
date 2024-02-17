//
//  TargetDependency+extension.swift
//  ProjectDescriptionHelpers
//
//  Created by woojin Shin on 2023/11/09.
//

import ProjectDescription

// MARK: Swift Package Manager External ZIP

public extension TargetDependency {
    enum SPM {}
}

public extension TargetDependency.SPM {
//    static let RxSwift = TargetDependency.external(name: "RxSwift")
//    static let AlamoFire = TargetDependency.external(name: "Alamofire")
//    static let firestore = TargetDependency.external(name: "FirebaseFirestore")
//    static let fireAuth = TargetDependency.external(name: "FirebaseAuth")
//    static let analytics = TargetDependency.external(name: "FirebaseAnalytics")
//    static let fireCore = TargetDependency.external(name: "FirebaseCore")
//    static let firestoreSwift = TargetDependency.external(name: "FirebaseFirestoreSwift")
//    static let googleAD = TargetDependency.external(name: "GoogleMobileAds")
//    static let Gzip = TargetDependency.external(name: "Gzip")
}

// MARK: - Xcode SPM 방식으로 리팩토링 진행 (서연 #99)

public extension TargetDependency {
    static let firestore: TargetDependency = .package(product: "FirebaseFirestore")
    static let firestoreSwift: TargetDependency = .package(product: "FirebaseFirestoreSwift") //FirebaseFirestoreSwift
    static let firebaseCrashlytics: TargetDependency = .package(product: "FirebaseCrashlytics")
    static let googleAD: TargetDependency = .package(product: "GoogleMobileAds")
    static let Gzip: TargetDependency = .package(product: "Gzip")
}

public extension Package {
    static let firebase: Package =  .remote(url: "https://github.com/firebase/firebase-ios-sdk.git",
                                            requirement: .upToNextMajor(from: "10.16.0"))
    static let goolgeAD: Package = .remote(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
                                           requirement: .upToNextMajor(from: "11.0.1"))
    static let Gzip: Package = .remote(url: "https://github.com/1024jp/GzipSwift.git",
                                       requirement: .upToNextMajor(from: "6.0.1"))
    
}


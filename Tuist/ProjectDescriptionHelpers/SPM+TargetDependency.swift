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
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let AlamoFire = TargetDependency.external(name: "Alamofire")
    static let firestore = TargetDependency.external(name: "FirebaseFirestore")
    static let fireAuth = TargetDependency.external(name: "FirebaseAuth")
//    static let analytics = TargetDependency.external(name: "FirebaseAnalytics")
//    static let fireCore = TargetDependency.external(name: "FirebaseCore")
    static let firestoreSwift = TargetDependency.external(name: "FirebaseFirestoreSwift")
    static let googleAD = TargetDependency.external(name: "GoogleMobileAds")
}

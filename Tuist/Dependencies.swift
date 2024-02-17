//
//  Dependencies.swift
//  Config
//
//  Created by woojin Shin on 2023/11/22.
//
// Dependencies 파일에 생성된 Dependecies는 추후 tuist fetch를 통해서 해당 패키지 정보를 불러와서 로컬에 저장해둔다.

import ProjectDescription

// MARK: - Xcode SPM 변경으로 인한 사용X
let denpendencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .branch("main")),
        .remote(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", requirement: .upToNextMajor(from: "10.14.0")),
        .remote(url: "https://github.com/1024jp/GzipSwift.git", requirement: .upToNextMajor(from: "6.0.1")),
    ],

    platforms: [.iOS]
)

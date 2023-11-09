//
//  Dependencies.swift
//  MetroCity_TDSManifests
//
//  Created by woojin Shin on 2023/11/09.
//

import ProjectDescription

// Dependencies 파일에 생성된 Dependecies는 추후 tuist fetch를 통해서 해당 패키지 정보를 불러와서 로컬에 저장해둔다.

let denpendencies = Dependencies(
    swiftPackageManager: [
        // Alamofire
//        .remote(url: "https://github.com/Alamofire/Alamofire.git",
//                requirement:.upToNextMajor(from: "5.8.1")),
        
        // RxSwift
//        .remote(
//            url: "https://github.com/ReactiveX/RxSwift.git",
//            requirement: .upToNextMajor(from: "6.6.0")
//        )
    ],
    
    platforms: [.iOS]
)

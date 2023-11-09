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
}

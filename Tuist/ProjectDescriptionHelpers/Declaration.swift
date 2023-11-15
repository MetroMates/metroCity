//
//  Declaration.swift
//  ProjectDescriptionHelpers
//
//  Created by woojin Shin on 2023/11/09.
//

import ProjectDescription
import Foundation

// 폴더는 직접 수동으로 생성하여야 한다.
// Manifests에서 보여지는 파일은 Project, Workspaces, Dependencies, Config 이름을 가진 swift파일이다.
// 이는 폴더도 해당된다. 해당 폴더안에 저 4종류의 파일중 하나라도 있어야 보인다. -> 아닐시 Finder에서만 보임.

/// 오늘 일자 가져옴.
var dateToString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd EEE a hh:mm"
    dateFormatter.locale = Locale(identifier: "ko_kr") // 한국 시간 지정
    dateFormatter.timeZone = TimeZone(abbreviation: "KST") // 한국 시간대 지정
    return dateFormatter.string(from: Date())
}

/// Workspace명 -> 현재 안씀.
public let workspaceName: String = "MetroCity"

/// Project명
public let projectNm: String = "MetroCity"

/// Project -> .proj 파일 위치 폴더명
public let projectFolder: String = "App"

/// organization 명
public let organizationName: String = "TDS"


/// New File 주석 Template
let firstHeadTemplate: String = "___COPYRIGHT___ \(dateToString) 꿀꿀🐷"

/// Target 담아두기
public var confirmTargets: [Target] = []

/// Target 추가함수
public func addTargets(_ target: [Target]) -> Bool {
    confirmTargets += target
    
    return true
}

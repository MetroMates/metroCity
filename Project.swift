//
//  Project.swift
//  MetroCity_TDSManifests
//
//  Created by woojin Shin on 2023/11/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

// 메인 App 타겟 생성
let mainTarget = Target.makeTargetWithTest(name: "MetroCity",
                                           platform: .iOS,
                                           product: .app,
                                           orgName: organizationName,
                                           deploymentTarget: .iOS(targetVersion: "16.4",
                                                                  devices: [.iphone,.ipad],
                                                                  supportsMacDesignedForIOS: true),
                                           dependencies: [.target(name: "SPM")],
                                           infoPlistPath: "Support/Info.plist",
                                           scripts: [.SwiftLintShell],
                                           isResource: true,
                                           isTestAt: true)

let a = addTargets(mainTarget)

// SPM 타겟 생성
let spmTarget = Target.makeTargetWithTest(name: "SPM",
                                          platform: .iOS,
                                          product: .framework,
                                          orgName: organizationName,
                                          deploymentTarget: .iOS(targetVersion: "16.4",
                                                                 devices: [.iphone,.ipad],
                                                                 supportsMacDesignedForIOS: true),
                                          dependencies: [],
                                          infoPlistPath: "",
                                          isResource: false,
                                          isTestAt: false)

let b = addTargets(spmTarget)


// ↑↑↑ 만들어진 타겟으로 프로젝트 생성
let project = Project.makeProject(projectName: projectName,
                                  orgName: organizationName)


//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by woojin Shin on 2023/11/21.
//

import ProjectDescription
import ProjectDescriptionHelpers

// 메인 App 타겟 생성
let appTarget = Target.makeTarget(name: "MetroCity",
                                  platform: .iOS,
                                  product: .app,
                                  orgName: organizationName,
                                  deploymentTarget: .iOS(targetVersion: "16.4",
                                                         devices: [.iphone, .ipad],
                                                         supportsMacDesignedForIOS: false),
                                  dependencies: [.project(target: "FirebaseSPM",
                                                          path: .relativeToRoot("\(projectFolder)/FirebaseSPM")),
                                                 
                                                 .project(target: "SPM",
                                                          path: .relativeToRoot("\(projectFolder)/SPM"))
                                                ],
                                  infoPlistPath: "Support/Info.plist",
                                  scripts: [.swiftLintPath],
                                  isResource: true,
                                  isTestAt: true)

// ↑↑↑ 만들어진 타겟으로 프로젝트 생성
let appProject = Project.makeProject(projectName: "MetroCity",
                                     orgName: organizationName,
                                     targets: appTarget,
                                     isXcconfigSet: true,
                                     additionalFiles: [],
                                     packages: [])

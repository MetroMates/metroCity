//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by woojin Shin on 2023/11/21.
//

import ProjectDescription
import ProjectDescriptionHelpers


// SPM 타겟 생성
let spmTarget = Target.makeTarget(name: "SPM",
                                  platform: .iOS,
                                  product: .framework,
                                  orgName: organizationName,
                                  deploymentTarget: .iOS(targetVersion: "16.4",
                                                         devices: [.iphone, .ipad],
                                                         supportsMacDesignedForIOS: false),
                                  dependencies: [],
                                  infoPlistPath: "",
                                  isResource: false,
                                  isTestAt: false)

let spmProject = Project.makeProject(projectName: "SPM",
                                     orgName: organizationName,
                                     targets: spmTarget)

//
//  Project.swift
//  Manifests
//
//  Created by woojin Shin on 2023/11/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

// 메인 App 타겟 생성
let firebaseTarget = Target.makeTarget(name: "FirebaseSPM",
                                       platform: .iOS,
                                       product: .staticFramework,
                                       orgName: organizationName,
                                       deploymentTarget: .iOS(targetVersion: "16.4",
                                                              devices: [.iphone, .ipad],
                                                              supportsMacDesignedForIOS: false),
                                       dependencies: [.firebaseCrashlytics,
                                                      .firestore,
                                                      .firestoreSwift,
                                                      .googleAD],
                                       infoPlistPath: "",
                                       scripts: [],
                                       isResource: false,
                                       isTestAt: false)

// ↑↑↑ 만들어진 타겟으로 프로젝트 생성
let firebaseProject = Project.makeProject(projectName: "FirebaseSPM",
                                     orgName: organizationName,
                                     targets: firebaseTarget,
                                          additionalFiles: [],
                                          packages: [.firebase, .goolgeAD])

//
//  Project+PrivateFunc.swift
//  ProjectDescriptionHelpers
//
//  Created by woojin Shin on 2023/11/09.
//

import ProjectDescription


extension Target {
    /// 타겟을 만들어준다. isTestAt이 true인 경우 Test 타겟도 같이 만든다.
    /// 이때 Test타겟의 경로에 해당하는 Test폴더는 직접 만들어주어야한다. -> Tests라는 폴더명으로 만들기
    public static func makeTarget(name: String,
                                          platform: Platform = .iOS,
                                          product: Product,
                                          orgName: String,
                                          deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.4",
                                                                                    devices: [.iphone, .ipad],
                                                                                    supportsMacDesignedForIOS: true),
                                          dependencies: [TargetDependency] = [],
                                          infoPlistPath: String = "",
                                          scripts: [TargetScript] = [],
                                          isResource: Bool = false,
                                          isTestAt: Bool = false) -> [Self] {
        
        // Target 생성 폴더명
        var folderNm: String {
            return "\(name)/"
        }
        
        let sources: SourceFilesList = ["Sources/**"]
//        ["\(projectFolder)/\(folderNm)Sources/**"]
        
        
        var resources: ResourceFileElements? {
            if isResource {
                return ["Resources/**"]
                // ["\(projectFolder)/\(folderNm)Resources/**"]
            } else {
                return nil
            }
        }
        
        var infoPlist: InfoPlist {
            if infoPlistPath.isEmpty {
                return .default
            } else {
                return .file(path: "\(infoPlistPath)")
            }
        }
        
        // Bundle 아이디 (Target에서 필요)
        let bundleID: String = "com.\(orgName).\(name)"
        
        // 메인 타겟
        let mainTarget = Target(name: name,
                                platform: platform,
                                product: product,
//                                productName: <#T##String?#>,
                                bundleId: bundleID,
                                deploymentTarget: deploymentTarget,
                                infoPlist: infoPlist,
                                sources: sources,
                                resources: resources,
//                                copyFiles: <#T##[CopyFilesAction]?#>,
//                                headers: <#T##Headers?#>,
//                                entitlements: <#T##Entitlements?#>,
                                scripts: scripts,
                                dependencies: dependencies
//                                settings: <#T##Settings?#>,
//                                coreDataModels: <#T##[CoreDataModel]#>,
//                                environmentVariables: <#T##[String : EnvironmentVariable]#>,
//                                launchArguments: <#T##[LaunchArgument]#>,
//                                additionalFiles: <#T##[FileElement]#>,
//                                buildRules: <#T##[BuildRule]#>
        )
        
        
        var targets: [Target] = [mainTarget]
        
        // Test 타겟 생성여부.
        if isTestAt {
            let testTarget = Target(name: "\(name)Tests",
                                    platform: platform,
                                    product: .unitTests,
                                    bundleId: "\(bundleID)Tests",
                                    deploymentTarget: deploymentTarget,
                                    infoPlist: .default,
                                    sources: ["Tests/**"],
                                    dependencies: [.target(name: name)] // -> 위에 만든 mainTarget을 의존. mainTarget의 name
            )
            targets.append(testTarget)
            
        }
        
        return targets
    }
}

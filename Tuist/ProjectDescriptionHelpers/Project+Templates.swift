import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

/*
 1. Target 만들기 (2개)
 - App Target
 - Dependecies용 Target
 2. 스키마 만들기 (1개)
 - 기본설정 해놓기
 3. Project 만들기 (1개)
 
 */


extension Project {
    
    public static func makeProject(projectName: String,
                                   orgName: String) -> Project {
        
        guard !confirmTargets.isEmpty else { return .init(name: "ErrorProject") }
        
        
        // 빌드 세팅 (xcconfig 있을경우)
        let setting = Settings.settings(configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("\(projectFolder)/\(projectName)/Resources/Config/Secrets.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("\(projectFolder)/\(projectName)/Resources/Config/Secrets.xcconfig")),
        ], defaultSettings: .recommended)
        
       // 빌드 세팅 (기본)
//        let setting: Settings = .settings(base: [:],
//                                          configurations: [.debug(name: .debug),
//                                                           .release(name: .release)],
//                                          defaultSettings: .recommended)
        
        // 현재 생성되는 프로젝트(name)에 대한 scheme 생성
        let schemes: [Scheme] = [.makeScheme(target: .debug, name: projectName)]
        
        // swift 파일 생성시 나타나는 주석템플릿양식
        var fileheaderTemplate: FileHeaderTemplate? = nil
        if !firstHeadTemplate.isEmpty {
            fileheaderTemplate = .string(firstHeadTemplate)
        }
        
        
        return Project(name: projectName,
                       organizationName: orgName,
//                       options: Project.Options,
//                       packages: [Package],
                       settings: setting,
                       targets: confirmTargets,
                       schemes: schemes,
                       fileHeaderTemplate: fileheaderTemplate,
                       additionalFiles: ["README.md"]
//                       resourceSynthesizers: [ResourceSynthesizer]
        )
    }
    
    /// Project 생성
    /// - name: 프로젝트명
    /// - platform: 플랫폼( ios, macod... )
    /// - product: 제품타입 (app, framework, ...)
    /// - orgName: organization명
    /// - deploymentTarget: 배포대상( ios 버전, 기기: iphone, ipad.. )
    /// - dependencies: 의존 경로
    /// - sources: 실제 작성된 코드가 존재하는 경로
    /// - resources: asset, font 등과 같은 리소스들이 모여있는 경로
    /// - infoPlist: infoPlist
    /// - isTestAt: 테스트타겟 생성여부. default false
//    public static func makeModule(projectName: String,
//                                   platform: Platform = .iOS,
//                                   product: Product,
//                                   orgName: String,
//                                   deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.4", 
//                                                                             devices: [.iphone, .ipad],
//                                                                             supportsMacDesignedForIOS: false),
//                                   dependencies: [TargetDependency],
//                                   sources: SourceFilesList = ["Sources/**"],
//                                   resources: ResourceFileElements? = nil,
//                                   infoPlist: InfoPlist = .default,
//                                   isTestAt: Bool = false) -> Project {
//                
//        // 빌드 세팅
//        let setting: Settings = .settings(base: [:],
//                                          configurations: [.debug(name: .debug),
//                                                           .release(name: .release)],
//                                          defaultSettings: .recommended)
//        // 타겟 생성
//        let targets: [Target] = Target.makeTargetWithTest(name: projectName,
//                                                          product: product,
//                                                          orgName: orgName,
//                                                          dependencies: dependencies,
//                                                          infoPlist: infoPlist,
//                                                          isResource: true,
//                                                          isTestAt: false)
//
//        
//        // 현재 생성되는 프로젝트(name)에 대한 scheme 생성
//        let schemes: [Scheme] = [.makeScheme(target: .debug, name: projectName)]
//        
//        // swift 파일 생성시 나타나는 주석템플릿양식
//        var fileheaderTemplate: FileHeaderTemplate? = nil
//        if !firstHeadTemplate.isEmpty {
//            fileheaderTemplate = .string(firstHeadTemplate)
//        }
//        
//        
//        return Project(name: projectName,
//                       organizationName: orgName,
////                       options: <#T##Project.Options#>,
////                       packages: <#T##[Package]#>,
//                       settings: setting,
//                       targets: targets,
//                       schemes: schemes,
//                       fileHeaderTemplate: fileheaderTemplate
////                       additionalFiles: [FileElement],
////                       resourceSynthesizers: [ResourceSynthesizer]
//        )
//    }
    
}



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
                                   orgName: String,
                                   targets: [Target],
                                   isXcconfigSet: Bool = false,
                                   additionalFiles: [FileElement] = [],
                                   packages: [Package]) -> Project {
        
        guard !targets.isEmpty else { return .init(name: "ErrorProject") }
        
        let isProductApp = targets.contains { target in
            target.product == .app
        }
        
        var setting: Settings?
        
        // 타겟이 App일경우만 세팅
        if isProductApp, isXcconfigSet {
            // 빌드 세팅 (xcconfig 있을경우)
            //$(inherited) -all_load
            setting = Settings.settings(base: ["OTHER_LDFLAGS":"-Objc"],
//            setting = Settings.settings(
                                        configurations: [
                                            .debug(name: "Debug", xcconfig: .relativeToRoot("\(projectFolder)/App/Resources/Config/Secrets.xcconfig")),
                                            .release(name: "Release", xcconfig: .relativeToRoot("\(projectFolder)/App/Resources/Config/Secrets.xcconfig")),
                                        ],
                                        defaultSettings: .recommended)
        } else {
            // 빌드 세팅 (기본)
            setting = .settings(base: [:],
                                              configurations: [.debug(name: .debug),
                                                               .release(name: .release)],
                                              defaultSettings: .recommended)
        }
        // 현재 생성되는 프로젝트(name)에 대한 scheme 생성
        var schemes: [Scheme] = []
        if isProductApp {
            schemes = [.makeScheme(target: .debug, name: projectName)]
        }
        
        // swift 파일 생성시 나타나는 주석템플릿양식
        var fileheaderTemplate: FileHeaderTemplate? = nil
        if !firstHeadTemplate.isEmpty {
            fileheaderTemplate = .string(firstHeadTemplate)
        }
        
        // 프로젝트명들 모아놓기
        projectNames.append(projectName)
        
        return Project(name: projectName,
                       organizationName: orgName,
                       packages: packages, // package 추가 #99
                       settings: setting,
                       targets: targets,
                       schemes: schemes,
                       fileHeaderTemplate: fileheaderTemplate,
                       additionalFiles: additionalFiles
        )
    }
}

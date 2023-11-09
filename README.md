# metroCity
실시간 지하철

## SPM 추가방법
1. 터미널 오픈
2. tuist edit -> Manifests Open
3. Dependencies.swift 파일에서 주석되어있는 양식 따라서 ↓ 작성
```
 .remote(url: "https://github.com/Alamofire/Alamofire.git",
         requirement:.upToNextMajor(from: "5.8.1")),
```
5. ProjectDescriptionHelper 폴더 -> SPM+TargetDependency.swift 파일 오픈
6. 아래 양식과 동일하게 사용할 package 추가.
```
public extension TargetDependency.SPM {
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let AlamoFire = TargetDependency.external(name: "Alamofire")
}
```
7. Project.swift 파일 오픈
8. spmTarget 변수 찾아서 dependencies: [ ] ← 이배열에 5번에서 선언한 static 변수 집어넣기.
9. 완료 후 Manifests 창 닫고, tuist fetch 명령어로 package 정보 다운받기
10. tuist generate로 프로젝트 재실행~


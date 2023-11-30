// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import CoreData

final class CoreDataManger {
    /// 싱글톤으로 쓸경우는 컨테이너 -> MetroCity
    static let shared = CoreDataManger(containerName: "MetroCity")
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init(containerName: String) {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("코어데이터 로딩 중 에러 발생 \(error.localizedDescription)")
            } else {
                print("코어데이터 로딩 성공!")
                print(description) // 저장소 list 호출
            }
        }
        context = container.viewContext
    }
    
    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
            print("🫣코어데이터 저장 성공 !!")
        } catch let error {
            print("🫣코어데이터 변경사항 저장 실패! \(error)")
        }
    }
    
    // 데이터 패치 함수
    func getEntities<T: NSManagedObject>(entityName: String) -> [T] {
        let request = NSFetchRequest<T>(entityName: entityName)
        var entities: [T] = []

        do {
            entities = try context.fetch(request)
        } catch let error {
            print("An error occurred while fetching \(entityName) data! \(error), \(error.localizedDescription)")
        }

        print("👻 \(entityName) data patch completed ")
        print("👻 \(entities.count)")
        return entities
    }
}

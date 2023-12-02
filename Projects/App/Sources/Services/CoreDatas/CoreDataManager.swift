// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import CoreData

// 애플 swiftUI CoreData 예시에 struct로 되어있음. 이유가 뭘까?
final class CoreDataManger {
    static let shared = CoreDataManger()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "MetroCity")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("코어데이터 로딩 중 에러 발생 \(error.localizedDescription)")
            } else {
                print("코어데이터 로딩 성공!")
                print(description) // 저장소 list 호출
            }
        }
        context = container.viewContext
                
        // 기존에 저장되어있던 항목에 병합할건지 여부.
        context.automaticallyMergesChangesFromParent = true
    }

    func save() {}
    
    // MARK: - CRUD Methods
    
    func create() {
        
    }
    
    // 데이터 패치 함수
//    func getEntities<T: NSManagedObject>(entityName: String) -> [T] {
//        let request = NSFetchRequest<T>(entityName: entityName)
//        var entities: [T] = []
//
//        do {
//            entities = try context.fetch(request)
//        } catch let error {
//            print("An error occurred while fetching \(entityName) data! \(error), \(error.localizedDescription)")
//        }
//
//        print("👻 \(entityName) data patch completed ")
//        print("👻 \(entities.count)")
//        return entities
//    }
    
    /// 데이터 조회 (조건가능 <한컬럼>)
    func retrieve<Entity, Value>(type: Entity.Type,
                                 sortkey: WritableKeyPath<Entity, String>? = nil,
                                 sortAsc: Bool = true,
                                 column: WritableKeyPath<Entity, Value>? = nil,
                                 comparision: CoreDataManger.Comparisons = .equal,
                                 value: Value? = nil) -> [Entity] where Entity: NSManagedObject {
        
        let request = NSFetchRequest<Entity>(entityName: "\(type.self)")
        let sortDesription = NSSortDescriptor(key: sortkey?.toKeyName, ascending: sortAsc)

        // 조건이 있는 경우.
        if let column, let value {
            request.predicate = NSPredicate(format: "%K \(comparision.rawValue) %@", column.toKeyName, "\(value)")
        }
        // 현재는 이렇게 조회된 NSMangedObject를 직접 쓰는게 아니기때문에 Sort를 줘도 의미가 없음.
        request.sortDescriptors?.append(sortDesription)
        
        do {
            let results = try context.fetch(request)
            
            return results
        } catch {
            print(error.localizedDescription)
        }

        return []
    }
    
    /// 데이터 조회 (전체조회)
    func retrieve<Entity>(type: Entity.Type,
                          sortkey: WritableKeyPath<Entity, String>? = nil,
                          sortAsc: Bool = true) -> [Entity] where Entity: NSManagedObject {
        
        let request = NSFetchRequest<Entity>(entityName: "\(type.self)")
        let sortDesription = NSSortDescriptor(key: sortkey?.toKeyName, ascending: sortAsc)
        
        request.sortDescriptors?.append(sortDesription)
        
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    /// 수정
    func update<Entity, Value>(type: Entity.Type, column: WritableKeyPath<Entity, Value>, value: Value) -> Bool where Entity: NSManagedObject {
        let beforeData = self.retrieve(type: type, column: column, comparision: .equal, value: value).first
        guard let beforeData else { return false }
        
        
        
        return true
    }
    
    /// 해당 데이터만 삭제
    func delete<Entity, Value>(type: Entity.Type, column: WritableKeyPath<Entity, Value>, value: Value) -> Bool where Entity: NSManagedObject {
        let deleteData = self.retrieve(type: type, column: column, comparision: .equal, value: value).first
        guard let deleteData else { return false }
        
        context.delete(deleteData)
        
        if !self.save() { return false }
        
        return true
    }
    
    /// 해당 타입 전체삭제.
    func deleteAll<Entity>(type: Entity.Type) -> Bool where Entity: NSManagedObject {
        let allDatas = self.retrieve(type: type)
        
        for data in allDatas {
            context.delete(data)
        }
        
        if !self.save() { return false }
        
        return true
    }
    
}

extension CoreDataManger {
    private func save() -> Bool {
        guard context.hasChanges
        else {
            print("🫣 코어데이터 변경사항 없음.")
            return false
        }
        
        do {
            try context.save()
            print("🫣 코어데이터 저장 성공 !!")
            return true
        } catch {
            print("🫣 코어데이터 변경사항 저장 실패! \(error.localizedDescription)")
            return false
        }
        
    }
    
    enum Comparisons: String {
        case equal = "=="          // ==
        case lessThan = "<"       // <
        case overThan = ">"      // >
        case lessOrEqual = "<="   // <=
        case overOrEqual = ">="   // >=
        case notEqual = "!="      // !=
    }
}

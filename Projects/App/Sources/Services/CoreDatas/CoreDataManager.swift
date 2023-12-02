// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import Foundation
import CoreData

// 애플 swiftUI CoreData 예시에 struct로 되어있음. 이유가 뭘까?
final class CoreDataManger {
    static let shared = CoreDataManger()
    
    private let container: NSPersistentContainer
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
    
    // NSEntityDescription.entity() 이건 Entity를 새로 만들경우 사용.

    // MARK: - CRUD Methods
    /// 여러 Entity의 내용을 한번에 등록할 경우.
    func create(newEntityDataHandler: () -> Void) -> Bool {
        print("📝 CoreDataManager create")
        newEntityDataHandler()
        return self.save()
    }
            
    /// 데이터 조회 (조건가능 <한컬럼>)
    func retrieve<Entity, Value>(type: Entity.Type,
                                 sortkey: WritableKeyPath<Entity, String>? = nil,
                                 sortAsc: Bool = true,
                                 column: WritableKeyPath<Entity, Value>? = nil,
                                 comparision: CoreDataManger.Comparisons = .equal,
                                 value: Value? = nil) -> [Entity] where Entity: NSManagedObject {
        print("📝 CoreDataManager Retrieve")
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
        print("CoreDataManager Retrieve")
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
    /// clouser에 entity.setValue("변경할 데이터", forKey: "컬럼명") 의 형식으로 작성.!!
    func update<Entity, Value>(type: Entity.Type,
                               column: WritableKeyPath<Entity, Value>,
                               value: Value,
                               newValueHandler: ([Entity]) -> Void) -> Bool where Entity: NSManagedObject {
        print("📝 CoreDataManager Update")
        let beforeDatas = self.retrieve(type: type, column: column, comparision: .equal, value: value)
        guard !beforeDatas.isEmpty else { return false }
        
        newValueHandler(beforeDatas)
        
        if !self.save() { return false }
        
        return true
    }

    /// 해당 데이터만 삭제
    func delete<Entity, Value>(type: Entity.Type, column: WritableKeyPath<Entity, Value>, value: Value) -> Bool where Entity: NSManagedObject {
        print("📝 CoreDataManager Delete")
        let deleteDatas = self.retrieve(type: type, column: column, comparision: .equal, value: value)
        guard !deleteDatas.isEmpty else { return false }
        
        deleteDatas.forEach { context.delete($0) }

        return self.save()
    }
    
    /// 해당 타입 전체삭제.
    func deleteAll<Entity>(type: Entity.Type) -> Bool where Entity: NSManagedObject {
        print("📝 CoreDataManager DeleteAll")
        let allDatas = self.retrieve(type: type)
        allDatas.forEach { context.delete($0) }
        if !self.save() { return false }
        
        return true
    }
    
}

extension CoreDataManger {
    private func save() -> Bool {
        guard context.hasChanges
        else {
            print("📝 코어데이터 변경사항 없음.")
            return false
        }
        
        do {
            try context.save()
            print("📝 코어데이터 저장 성공 !!")
            return true
        } catch {
            print("📝 코어데이터 변경사항 저장 실패! \(error.localizedDescription)")
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

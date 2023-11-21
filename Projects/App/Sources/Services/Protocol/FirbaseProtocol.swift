// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import Foundation

/// FireStore 서버통신용 객체 프로토콜
protocol FireStoreCodable: Codable { }

protocol FireStoreServiceDelegate {
    var collection: String { get }
    var documentID: String { get }
    func fetchAll()
    func fetchOne()
    func update()
    func delete()
    func insert()
}

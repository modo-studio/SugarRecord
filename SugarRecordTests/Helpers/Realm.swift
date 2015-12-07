import Foundation
import RealmSwift

func testRealm() -> Realm {
    return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
}
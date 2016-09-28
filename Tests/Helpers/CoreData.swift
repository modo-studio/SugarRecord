import Foundation
import CoreData

@testable import SugarRecord

func testCoreData() -> CoreDataDefaultStorage {
    let store = CoreDataStore.named("testing")
    let bundle = Bundle(for: CoreDataDefaultStorageTests.classForCoder())
    let model = CoreDataObjectModel.merged([bundle])
    let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
    return defaultStorage
}

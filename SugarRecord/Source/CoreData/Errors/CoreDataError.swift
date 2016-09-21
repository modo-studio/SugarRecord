import CoreData
import Foundation

public enum CoreDataError: Error {
    case invalidModel(CoreDataObjectModel)
    case persistenceStoreInitialization
}

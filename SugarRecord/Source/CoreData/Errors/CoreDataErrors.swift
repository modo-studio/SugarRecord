import CoreData
import Foundation

public extension CoreData {
    
    public enum CoreDataError: Error {
        case InvalidModel(CoreData.ObjectModel)
        case PersistenceStoreInitialization
    }
    
}

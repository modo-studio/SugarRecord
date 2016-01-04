import CoreData
import Foundation

// MARK: - CoreData namespace

public extension CoreData {
    
    public enum Error: ErrorType {
        case InvalidModel(CoreData.ObjectModel)
        case PersistenceStoreInitialization
    }
    
}

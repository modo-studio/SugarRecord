import CoreData
import Foundation

public extension CoreData {
    
    public enum Error: ErrorType {
        case InvalidModel(CoreData.ObjectModel)
        case PersistenceStoreInitialization
    }
    
}

import Foundation
import CoreData

extension CoreData {

    enum ContextParent {
        case Coordinator(NSPersistentStoreCoordinator)
        case Context(NSManagedObjectContext)
    }
    
}

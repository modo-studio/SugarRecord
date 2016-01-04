import Foundation
import CoreData

// MARK: - CoreData.ContextParent

extension CoreData {
    /**
     It defines a context parent
     - Coordinator: persistent store coordinator
     - Context:     managed objcet context
     */
    enum ContextParent {
        case Coordinator(NSPersistentStoreCoordinator)
        case Context(NSManagedObjectContext)
    }
}

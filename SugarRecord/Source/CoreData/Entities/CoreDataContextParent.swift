import Foundation
import CoreData

enum CoreDataContextParent {
    case coordinator(NSPersistentStoreCoordinator)
    case context(NSManagedObjectContext)
}

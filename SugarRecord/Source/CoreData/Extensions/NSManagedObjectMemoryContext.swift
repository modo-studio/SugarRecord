import Foundation
import CoreData

/// NSManagedObjectContext that doesn't persist its changes.
class NSManagedObjectMemoryContext: NSManagedObjectContext {
    
    /**
     Memory context that doesn't persist the changes.
     
     - throws: Throws nothing.
     */
    override func save() throws {
        // Do nothing
    }

}

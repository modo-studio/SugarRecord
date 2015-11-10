import Foundation
import CoreData

// MARK: - Entity Protocol

extension NSManagedObject {
    
    public static var entityName: String {
        get {
            return NSStringFromClass(self)
        }
    }
    
}


// MARK: - NSManagedObject Extension (Requestable)

extension NSManagedObject: Requestable {}


// MARK: - NSManagedobjecte Extension (Entity)

extension NSManagedObject: Entity {}
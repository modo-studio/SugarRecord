import Foundation
import CoreData

// MARK: - Entity Protocol

extension NSManagedObject: Entity {
    
    public static var entityName: String {
        get {
            return NSStringFromClass(self)
        }
    }
    
}

// MARK: - Fetchable Protocol

extension NSManagedObject: Requestable {}
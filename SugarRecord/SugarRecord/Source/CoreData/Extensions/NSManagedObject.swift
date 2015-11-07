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

extension NSManagedObject: Requestable {}

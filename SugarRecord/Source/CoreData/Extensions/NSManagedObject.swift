import Foundation
import CoreData

// MARK: - Entity Protocol

extension NSManagedObject {
    
    public class var entityName: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
}


// MARK: - NSManagedObject Extension (Entity)

extension NSManagedObject: Entity {}


// MARK: - NSManagedObject (Request builder)

extension NSManagedObject {
    
    
    static func request<T: Entity>(requestable: Requestable) -> Request<T> {
        return Request(requestable)
    }

}

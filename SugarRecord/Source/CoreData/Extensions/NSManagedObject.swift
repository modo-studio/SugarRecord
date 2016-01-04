import Foundation
import CoreData

// MARK: - Entity Protocol

extension NSManagedObject {
    
    public static var entityName: String {
        get {
            return NSStringFromClass(self).componentsSeparatedByString(".").last!
        }
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

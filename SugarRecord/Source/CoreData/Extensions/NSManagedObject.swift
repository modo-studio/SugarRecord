import Foundation
import CoreData

// MARK: - Entity Protocol

extension NSManagedObject {
    
    open class var entityName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!.replacingOccurrences(of: "Entity", with: "")
    }
    
}


// MARK: - NSManagedObject Extension (Entity)

extension NSManagedObject: Entity {}


// MARK: - NSManagedObject (Request builder)

extension NSManagedObject {
    
    
    static func request<T: Entity>(requestable: Requestable) -> FetchRequest<T> {
        return FetchRequest(requestable)
    }

}

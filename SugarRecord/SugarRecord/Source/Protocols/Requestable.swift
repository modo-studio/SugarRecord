import Foundation

/**
 *  Protocol that specifies that the element that conforms it can be requested using a Request
 */
protocol Requestable {
    
    /**
     Returns a request with the provided predicate & sort descriptor
     
     - parameter predicate:      request predicate
     - parameter sortDescriptor: request sort descriptor
     
     - returns: initialized request
     */
    static func with<T>(predicate predicate: NSPredicate, sortDescriptor: NSSortDescriptor)  -> Request<T>
    
    /**
     Returns a request with the provided predicate
     
     - parameter predicate: request predicate
     
     - returns: initialized request
     */
    static func with<T>(predicate predicate: NSPredicate)  -> Request<T>
    
    /**
     Returns a request with the provided sort descriptor
     
     - parameter sortDescriptor: request sort descriptor
     
     - returns: initialized request
     */
    static func with<T>(sortDescriptor sortDescriptor: NSSortDescriptor)  -> Request<T>
}

extension Requestable {
    
    static func with<T>(predicate predicate: NSPredicate, sortDescriptor: NSSortDescriptor)  -> Request<T> {
        return Request()
            .request(withSortDescriptor: sortDescriptor)
            .request(withPredicate: predicate)
    }
    
    static func with<T>(predicate predicate: NSPredicate)  -> Request<T> {
        return Request()
            .request(withPredicate: predicate)
    }
    
    static func with<T>(sortDescriptor sortDescriptor: NSSortDescriptor)  -> Request<T> {
        return Request()
            .request(withSortDescriptor: sortDescriptor)
    }
}


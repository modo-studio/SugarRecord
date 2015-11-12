import Foundation

/**
 *  Protocol that specifies that the element that conforms it can be requested using a Request
 */
protocol Requestable {
    
    /**
     Returns a request with the provided predicate & sort descriptor.
     
     - parameter predicate:      Request predicate.
     - parameter sortDescriptor: Request sort descriptor.
     
     - returns: Initialized request
     */
    static func with<T>(predicate predicate: NSPredicate, sortDescriptor: NSSortDescriptor)  -> Request<T>
    
    /**
     Returns a request with the provided predicate
     
     - parameter predicate: request predicate
     
     - returns: Initialized request
     */
    static func filteredWith<T>(predicate predicate: NSPredicate)  -> Request<T>
    
    /**
     Returns a request filtering using the format string and the list of arguments. Internally this request creates the NSPredicate with the provided data.
     
     - parameter predicateFormat: Predicate format.
     - parameter argList:         Predicate arguments list.
     
     - returns: Initialized Request.
     */
    static func filteredWith<T>(format predicateFormat: String, arguments argList: CVaListPointer) -> Request<T>
    
    /**
     Returns a request filtering by the provided key equal to the value given.
     
     - parameter key:   Filter key.
     - parameter value: Filter value.
     
     - returns: Initialized Request.
     */
    static func filteredWith<T>(key: String, equalTo value: String) -> Request<T>

    /**
     Returns a request with the provided sort descriptor.
     
     - parameter sortDescriptor: request sort descriptor.
     
     - returns: Initialized Request.
     */
    static func sortedWith<T>(sortDescriptor sortDescriptor: NSSortDescriptor)  -> Request<T>
    
    /**
     Returns a request that sorts with the provided info.
     
     - parameter key:       Sorting key.
     - parameter ascending: Results order.
     - parameter cmptr:     Comparator.
     
     - returns: Initialized Request.
     */
    static func sortedWith<T>(key: String?, ascending: Bool, comparator cmptr: NSComparator) -> Request<T>

    /**
     Returns a request that sorts by the provided key and ascending value
     
     - parameter key:       Sorting key.
     - parameter ascending: Results order.
     
     - returns: Initialized Request.
     */
    static func sortedWith<T>(key: String?, ascending: Bool) -> Request<T>
    
    /**
     Returns a request that sorts using the provided data.
     
     - parameter key:       Sorting key.
     - parameter ascending: Results order.
     - parameter selector:  Selector
     
     - returns: Initialized Request.
     */
    static func sortedWith<T>(key: String?, ascending: Bool, selector: Selector) -> Request<T>
}

extension Requestable {
    
    static func with<T>(predicate predicate: NSPredicate, sortDescriptor: NSSortDescriptor)  -> Request<T> {
        return Request()
            .request(withSortDescriptor: sortDescriptor)
            .request(withPredicate: predicate)
    }
    
    static func filteredWith<T>(predicate predicate: NSPredicate)  -> Request<T> {
        return Request()
            .request(withPredicate: predicate)
    }
    
    static func filteredWith<T>(format predicateFormat: String, arguments argList: CVaListPointer) -> Request<T> {
        return Request()
            .request(withPredicate: NSPredicate(format: predicateFormat, arguments: argList))
    }
    
    static func filteredWith<T>(key: String, equalTo value: String) -> Request<T>{
        return Request()
            .request(withPredicate: NSPredicate(format: "\(key) == %@", value))
    }
    
    static func sortedWith<T>(sortDescriptor sortDescriptor: NSSortDescriptor)  -> Request<T> {
        return Request()
            .request(withSortDescriptor: sortDescriptor)
    }
    
    static func sortedWith<T>(key: String?, ascending: Bool, comparator cmptr: NSComparator) -> Request<T> {
        return Request()
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending, comparator: cmptr))
    }
    
    static func sortedWith<T>(key: String?, ascending: Bool) -> Request<T> {
        return Request()
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending))
    }
    
    static func sortedWith<T>(key: String?, ascending: Bool, selector: Selector) -> Request<T> {
        return Request()
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending, selector: selector))
    }
}




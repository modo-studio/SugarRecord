import Foundation

public struct Request<T: Entity> {
    
    // MARK: - Attributes
    
    /// Sort descriptor
    public let sortDescriptor: NSSortDescriptor?
    
    /// Predicate
    public let predicate: NSPredicate?
    
    
    /// Context
    let context: Context?
    
    
    // MARK: - Init
    
    /**
     Initializes the request with the provided context, sort descriptor and predicate
     
     - parameter requestable:    requestable
     - parameter sortDescriptor: sort descriptor
     - parameter predicate:      predicate
     
     - returns: initialized Request
     */
    public init(_ requestable: Requestable? = nil, sortDescriptor: NSSortDescriptor? = nil, predicate: NSPredicate? = nil) {
        self.context = requestable?.requestContext()
        self.sortDescriptor = sortDescriptor
        self.predicate = predicate
    }
    
    
    // MARK: - Public Fetching Methods
    
    /**
    Executes the fetch request.
    
    - throws: Throws an Error if the request couldn't be executed.
    
    - returns: Fetch results.
    */
    public func fetch() throws -> [T] {
        return try context!.fetch(self)
    }
    
    /**
     Executes the fetch request in the given requestable.
     
     - parameter requestable: Requestable where the request will be executed.
     
     - throws: Throws an Error if the request couldn't be executed.
     
     - returns: Fetch results.
     */
    public func fetch(requestable: Requestable) throws -> [T] {
        return try requestable.requestContext().fetch(self)
    }
    
    
    // MARK: - Public Builder Methods
    
    public func filteredWith(predicate predicate: NSPredicate) -> Request<T> {
        return self
            .request(withPredicate: predicate)
    }
    
    public func filteredWith(key: String, equalTo value: String) -> Request<T> {
        return self
            .request(withPredicate: NSPredicate(format: "\(key) == %@", value))
    }
    
    public func sortedWith(sortDescriptor sortDescriptor: NSSortDescriptor) -> Request<T> {
        return self
            .request(withSortDescriptor: sortDescriptor)
    }
    
    public func sortedWith(key: String?, ascending: Bool, comparator cmptr: NSComparator) -> Request<T> {
        return self
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending, comparator: cmptr))
    }
    
    public func sortedWith(key: String?, ascending: Bool) -> Request<T> {
        return self
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending))
    }
    
    public func sortedWith(key: String?, ascending: Bool, selector: Selector) -> Request<T> {
        return self
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending, selector: selector))
    }
    
    
    // MARK: - Internal
    
    func request(withPredicate predicate: NSPredicate) -> Request<T> {
        return Request<T>(context, sortDescriptor: sortDescriptor, predicate: predicate)
    }
    
    func request(withSortDescriptor sortDescriptor: NSSortDescriptor) -> Request<T> {
        return Request<T>(context, sortDescriptor: sortDescriptor, predicate: predicate)
    }
    
}

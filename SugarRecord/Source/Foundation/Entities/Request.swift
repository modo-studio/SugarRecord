import Foundation

public struct Request<T: Entity> {
    
    // MARK: - Attributes
    
    public let sortDescriptor: NSSortDescriptor?
    public let predicate: NSPredicate?
    let context: Context?
    
    
    // MARK: - Init
    
    public init(_ requestable: Requestable? = nil, sortDescriptor: NSSortDescriptor? = nil, predicate: NSPredicate? = nil) {
        self.context = requestable?.requestContext()
        self.sortDescriptor = sortDescriptor
        self.predicate = predicate
    }
    
    
    // MARK: - Public Fetching Methods
    
    public func fetch() throws -> [T] {
        return try context!.fetch(self)
    }
    
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

import Foundation

public struct Request<T: Entity>: Equatable {
    
    // MARK: - Attributes
    
    public let sortDescriptor: NSSortDescriptor?
    public let predicate: NSPredicate?
    public let fetchOffset: Int
    public let fetchLimit: Int
    let context: Context?
    
    
    // MARK: - Init
    
    public init(_ requestable: Requestable? = nil, sortDescriptor: NSSortDescriptor? = nil, predicate: NSPredicate? = nil, fetchOffset: Int = 0, fetchLimit: Int = 0) {
        self.context = requestable?.requestContext()
        self.sortDescriptor = sortDescriptor
        self.predicate = predicate
        self.fetchOffset = fetchOffset
        self.fetchLimit = fetchLimit
    }
    
    
    // MARK: - Public Fetching Methods
    
    public func fetch() throws -> [T] {
        return try context!.fetch(self)
    }
    
    public func fetch(_ requestable: Requestable) throws -> [T] {
        return try requestable.requestContext().fetch(self)
    }
    
    
    // MARK: - Public Builder Methods
    
    public func filteredWith(predicate: NSPredicate) -> Request<T> {
        return self
            .request(withPredicate: predicate)
    }
    
    public func filteredWith(_ key: String, equalTo value: String) -> Request<T> {
        return self
            .request(withPredicate: NSPredicate(format: "\(key) == %@", value))
    }
    
    public func sortedWith(sortDescriptor: NSSortDescriptor) -> Request<T> {
        return self
            .request(withSortDescriptor: sortDescriptor)
    }
    
    public func sortedWith(_ key: String?, ascending: Bool, comparator cmptr: @escaping Comparator) -> Request<T> {
        return self
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending, comparator: cmptr))
    }
    
    public func sortedWith(_ key: String?, ascending: Bool) -> Request<T> {
        return self
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending))
    }
    
    public func sortedWith(_ key: String?, ascending: Bool, selector: Selector) -> Request<T> {
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


// MARK: - Equatable

public func == <T>(lhs: Request<T>, rhs: Request<T>) -> Bool {
    return lhs.sortDescriptor == rhs.sortDescriptor &&
    lhs.predicate == rhs.predicate
}

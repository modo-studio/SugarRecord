import Foundation

public struct Request<T: Entity>: Equatable {
    
    // MARK: - Attributes
    
    public let sortDescriptor: SortDescriptor?
    public let predicate: Predicate?
    let context: Context?
    
    
    // MARK: - Init
    
    public init(_ requestable: Requestable? = nil, sortDescriptor: SortDescriptor? = nil, predicate: Predicate? = nil) {
        self.context = requestable?.requestContext()
        self.sortDescriptor = sortDescriptor
        self.predicate = predicate
    }
    
    
    // MARK: - Public Fetching Methods
    
    public func fetch() throws -> [T] {
        return try context!.fetch(self)
    }
    
    public func fetch(_ requestable: Requestable) throws -> [T] {
        return try requestable.requestContext().fetch(self)
    }
    
    
    // MARK: - Public Builder Methods
    
    public func filteredWith(predicate: Predicate) -> Request<T> {
        return self
            .request(withPredicate: predicate)
    }
    
    public func filteredWith(_ key: String, equalTo value: String) -> Request<T> {
        return self
            .request(withPredicate: Predicate(format: "\(key) == %@", value))
    }
    
    public func sortedWith(sortDescriptor: SortDescriptor) -> Request<T> {
        return self
            .request(withSortDescriptor: sortDescriptor)
    }
    
    public func sortedWith(_ key: String?, ascending: Bool, comparator cmptr: Comparator) -> Request<T> {
        return self
            .request(withSortDescriptor: SortDescriptor(key: key, ascending: ascending, comparator: cmptr))
    }
    
    public func sortedWith(_ key: String?, ascending: Bool) -> Request<T> {
        return self
            .request(withSortDescriptor: SortDescriptor(key: key, ascending: ascending))
    }
    
    public func sortedWith(_ key: String?, ascending: Bool, selector: Selector) -> Request<T> {
        return self
            .request(withSortDescriptor: SortDescriptor(key: key, ascending: ascending, selector: selector))
    }
    
    
    // MARK: - Internal
    
    func request(withPredicate predicate: Predicate) -> Request<T> {
        return Request<T>(context, sortDescriptor: sortDescriptor, predicate: predicate)
    }
    
    func request(withSortDescriptor sortDescriptor: SortDescriptor) -> Request<T> {
        return Request<T>(context, sortDescriptor: sortDescriptor, predicate: predicate)
    }
    
}


// MARK: - Equatable

public func == <T>(lhs: Request<T>, rhs: Request<T>) -> Bool {
    return lhs.sortDescriptor == rhs.sortDescriptor &&
    lhs.predicate == rhs.predicate
}

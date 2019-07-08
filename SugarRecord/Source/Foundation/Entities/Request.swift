import Foundation

public struct FetchRequest<T: Entity>: Equatable {
    
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
    
    public init(_ context: Context, predicate: NSPredicate? = nil, fetchOffset: Int = 0, fetchLimit: Int = 0) {
        self.context = context
        self.sortDescriptor = nil
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
    
    
    public func query(attributes: [String]) throws -> [[String: Any]] {
        return try context!.query(self, attributes: attributes)
    }
    
    public func queryOne(attributes: [String]) throws -> [String: Any]? {
        return try context!.queryOne(self, attributes: attributes)
    }
    
    public func querySet(attribute: String) throws -> Set<String>? {
        return try context!.querySet(self, attribute: attribute)
    }
    
    public func fetchOne() throws -> T? {
        return try context!.fetchOne(self)
    }
    
    public func count() -> Int {
        return context!.count(self)
    }
    
    
    // MARK: - Public Builder Methods
    
    public func filtered(with predicate: NSPredicate) -> FetchRequest<T> {
        return self
            .request(withPredicate: predicate)
    }
    
    public func filtered(with key: String, equalTo value: String) -> FetchRequest<T> {
        return self
            .request(withPredicate: NSPredicate(format: "\(key) == %@", value))
    }
    
    public func filtered(with key: String, in value: [String]) -> FetchRequest<T> {
        return self
            .request(withPredicate: NSPredicate(format: "\(key) IN %@", value))
    }
    
    public func filtered(with key: String, notIn value: [String]) -> FetchRequest<T> {
        return self
            .request(withPredicate: NSPredicate(format: "NOT (\(key) IN %@)", value))
    }
    
    
    public func sorted(with sortDescriptor: NSSortDescriptor) -> FetchRequest<T> {
        return self
            .request(withSortDescriptor: sortDescriptor)
    }
    
    public func sorted(with key: String?, ascending: Bool, comparator cmptr: @escaping Comparator) -> FetchRequest<T> {
        return self
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending, comparator: cmptr))
    }
    
    public func sorted(with key: String?, ascending: Bool) -> FetchRequest<T> {
        return self
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending))
    }
    
    public func sorted(with key: String?, ascending: Bool, selector: Selector) -> FetchRequest<T> {
        return self
            .request(withSortDescriptor: NSSortDescriptor(key: key, ascending: ascending, selector: selector))
    }
    
    
    // MARK: - Internal
    
    func request(withPredicate predicate: NSPredicate) -> FetchRequest<T> {
        return FetchRequest<T>(context, sortDescriptor: sortDescriptor, predicate: predicate)
    }
    
    func request(withSortDescriptor sortDescriptor: NSSortDescriptor) -> FetchRequest<T> {
        return FetchRequest<T>(context, sortDescriptor: sortDescriptor, predicate: predicate)
    }
    
}


// MARK: - Equatable

public func == <T>(lhs: FetchRequest<T>, rhs: FetchRequest<T>) -> Bool {
    return lhs.sortDescriptor == rhs.sortDescriptor &&
        lhs.predicate == rhs.predicate
}

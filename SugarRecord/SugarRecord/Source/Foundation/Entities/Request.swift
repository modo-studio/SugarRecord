import Foundation
import Result

public struct Request<T: Entity> {
    
    // MARK: - Attributes
    
    /// Sort descriptor
    public let sortDescriptor: NSSortDescriptor?
    
    /// Predicate
    public let predicate: NSPredicate?
    
    
    /// Context
    let context: Context
    
    
    // MARK: - Init
    
    /**
     Initializes the request with the provided context, sort descriptor and predicate
     
     - parameter context:        context
     - parameter sortDescriptor: sort descriptor
     - parameter predicate:      predicate
     
     - returns: initialized Request
     */
    init(context: Context, sortDescriptor: NSSortDescriptor? = nil, predicate: NSPredicate? = nil) {
        self.context = context
        self.sortDescriptor = sortDescriptor
        self.predicate = predicate
    }
    
    
    // MARK: - Public Fetching Methods
    
    /**
    Execute the fetch request
    
    - returns: Result of the fetch reques(
    */
    public func fetch() -> Result<[T], Error> {
        return context.fetch(self)
    }
    
    
    // MARK: - Public Builder Methods
    
    public func filteredWith(predicate predicate: NSPredicate)  -> Request<T> {
        return self
            .request(withPredicate: predicate)
    }
    
    public func filteredWith(format predicateFormat: String, arguments argList: CVaListPointer) -> Request<T> {
        return self
            .request(withPredicate: NSPredicate(format: predicateFormat, arguments: argList))
    }
    
    public func filteredWith(key: String, equalTo value: String) -> Request<T>{
        return self
            .request(withPredicate: NSPredicate(format: "\(key) == %@", value))
    }
    
    public func sortedWith(sortDescriptor sortDescriptor: NSSortDescriptor)  -> Request<T> {
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
        return Request<T>(context: context, sortDescriptor: sortDescriptor, predicate: predicate)
    }
    
    func request(withSortDescriptor sortDescriptor: NSSortDescriptor) -> Request<T> {
        return Request<T>(context: context, sortDescriptor: sortDescriptor, predicate: predicate)
    }
}

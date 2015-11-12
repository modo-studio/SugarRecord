import Foundation
import ReactiveCocoa
import Result

public struct Request<T: Entity> {
    
    // MARK: - Attributes
    
    /// Sort descriptor
    public let sortDescriptor: NSSortDescriptor?
    
    /// Predicate
    public let predicate: NSPredicate?
    
    
    // MARK: - Init
    
    init(sortDescriptor: NSSortDescriptor? = nil, predicate: NSPredicate? = nil) {
        self.sortDescriptor = sortDescriptor
        self.predicate = predicate
    }
    
    
    // MARK: - Public
    
    func inContext(context: Context) -> Result<[T], Error> {
        return context.fetch(self)
    }
    
    func inStorage(storage: Storage) -> Result<[T], Error> {
        
        
        storage.mainContext.fetch(self)
        return Result(error: Error.InvalidType)
    }
    
//    func inContext(context: Context) -> ([T], Error?) {
//        return context.fetch(self)
//    }
    
//    func inStorage(storage: Storage) -> ([T], Error?) {
//        return inContext(storage.mainContext)
//    }
//    
//    
    // MARK: - Internal
    
    func request(withPredicate predicate: NSPredicate) -> Request<T> {
        return Request<T>(sortDescriptor: sortDescriptor, predicate: predicate)
    }
    
    func request(withSortDescriptor sortDescriptor: NSSortDescriptor) -> Request<T> {
        return Request<T>(sortDescriptor: sortDescriptor, predicate: predicate)
    }
}

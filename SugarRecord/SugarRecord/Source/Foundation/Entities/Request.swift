import Foundation
import ReactiveCocoa

public struct Request<T> {
    
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
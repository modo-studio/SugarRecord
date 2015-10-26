import Foundation
import CoreData
import ReactiveCocoa

extension NSManagedObjectContext: Context {
    
    public func fetch<T>(request: Request<T>) -> SignalProducer<[T], NoError> {
        return SignalProducer.empty
    }
    
    public func add<T>(objects: [T]) -> SignalProducer<Void, NoError> {
        return SignalProducer.empty
    }
    
    public func remove<T>(objects: [T]) -> SignalProducer<Void, NoError> {
        return SignalProducer.empty
    }
    
}
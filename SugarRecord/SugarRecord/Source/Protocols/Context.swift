import Foundation
import ReactiveCocoa

/**
 *  Context protocol. Database operations are executed agains a context. It works as a proxy for accessing the persistence solution.
 */
public protocol Context {
    
    /**
     Fetches objects and returns them using the provided request
     
     - parameter request: request to fetch the objects
     
     - returns: signal producer that executes the action
     */
    func rac_fetch<T: Entity>(request: Request<T>) -> SignalProducer<[T], Error>
    
    /**
     Fetches objects and returns them using the provided request
     
     - parameter request: request to fetch the objects
     
     - returns: request results and and an error (in case of any)
     */
    func fetch<T: Entity>(request: Request<T>) -> (results: [T], error: Error?)
    
    /**
     Inserts an object into the context
          
     - returns: signal producer that executes the action
     */
    func rac_insert<T: Entity>() -> SignalProducer<T, Error>
    
    /**
     Inserts an object into the context
     
     - returns: inserted object and an error (in case of any)
     */
    func insert<T: Entity>() -> (inserted: T, error: Error?)

    /**
     Removes objects from the context
     
     - parameter objects: objects to be removed
     
     - returns: signal producer that executes the action
     */
    func rac_remove<T: Entity>(objects: [T]) -> SignalProducer<Void, Error>
    
    /**
     Removes objects from the context
     
     - parameter objects: objects to be removed
     
     - returns: error (in case of any)
     */
    func remove<T: Entity>(objects: [T]) -> Error?
}
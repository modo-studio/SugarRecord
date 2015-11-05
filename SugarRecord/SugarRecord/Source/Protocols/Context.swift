import Foundation
import Result

/**
 *  Context protocol. It works as a proxy for accessing the persistence solution.
 */
public protocol Context {
    
     /**
     Fetches objects and returns them using the provided request
     
     - parameter request: request to fetch the object
     
     - returns: request results and an error (in case of any)
     */
    func fetch<T>(request: Request<T>) -> Result<[T], Error>
    
     /**
     Inserts an object into the context
     
     - returns: inserted object and an error (incase of any)
     */
    func insert<T>() -> Result<T, Error>
    
     /**
     Removes objets from the context
     
     - parameter objects: objects to be removed
     
     - returns: error (in case of any)
     */
    func remove<T>(objects: [T]) -> Result<Void, Error>
}
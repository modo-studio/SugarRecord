import Foundation

/**
 *  Requestable Protocol
 */
public protocol Requestable {
    
    /**
     Returns a context where the request can be executed.
     
     - returns: Context for executing the request into.
     */
    func requestContext() -> Context
    
    /**
     Creates a request for the given model
     
     - parameter model: model
     
     - returns: initialized request
     */
    func request<T>(model: T.Type) -> Request<T>
}

public extension Requestable where Self: Context {
    
    func requestContext() -> Context {
        return self
    }
    
    func request<T>(model: T.Type) -> Request<T> {
        return Request<T>(self)
    }

}

public extension Requestable where Self:Storage {
    
    func requestContext() -> Context {
        return self.mainContext
    }
    
    func request<T>(model: T.Type) -> Request<T> {
        return Request<T>(self.mainContext)
    }
    
}

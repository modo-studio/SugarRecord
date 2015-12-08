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
}

public extension Requestable where Self: Context {
    func requestContext() -> Context {
        return self
    }
}

public extension Requestable where Self:Storage {
    func requestContext() -> Context {
        return self.mainContext
    }
}
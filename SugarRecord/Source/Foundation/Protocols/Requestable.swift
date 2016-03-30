import Foundation

public protocol Requestable {
    
    func requestContext() -> Context
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

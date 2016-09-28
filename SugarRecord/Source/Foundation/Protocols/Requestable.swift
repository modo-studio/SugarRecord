import Foundation

public protocol Requestable {
    
    func requestContext() -> Context
    func request<T>(_ model: T.Type) -> FetchRequest<T>
    
}

public extension Requestable where Self: Context {
    
    func requestContext() -> Context {
        return self
    }
    
    func request<T>(_ model: T.Type) -> FetchRequest<T> {
        return FetchRequest<T>(self)
    }

}

public extension Requestable where Self:Storage {
    
    func requestContext() -> Context {
        return self.mainContext
    }
    
    func request<T>(_ model: T.Type) -> FetchRequest<T> {
        return FetchRequest<T>(self.mainContext)
    }
    
}

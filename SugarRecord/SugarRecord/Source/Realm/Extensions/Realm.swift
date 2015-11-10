import Foundation
import RealmSwift
import Result

extension Realm: Context {
    
    public func fetch<T>(request: Request<T>) -> Result<[T], Error> {
        //TODO
        return Result(value: [])
    }
    
    public func insert<T>() -> Result<T, Error> {
        //TODO
        return Result(error: Error.InvalidType)
    }
    
    public func remove<T>(objects: [T]) -> Result<Void, Error> {
        return Result(value: ())
    }
}
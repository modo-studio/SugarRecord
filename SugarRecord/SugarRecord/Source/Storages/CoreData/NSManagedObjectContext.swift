import Foundation
import CoreData
import Result

extension NSManagedObjectContext: Context {
    
    public func fetch<T>(request: Request<T>) -> Result<[T], Error> {
        //TODO
        return Result(value: [])
    }
    
    public func insert<T>() -> Result<T, Error> {
        guard let E = T.self as? NSManagedObject.Type else { return Result(error: .InvalidType) }
        let object = NSEntityDescription.insertNewObjectForEntityForName(E.entityName, inManagedObjectContext: self)
        if let inserted = object as? T {
            return Result(value: inserted)
        }
        else {
            return Result(error: .InvalidType)
        }
    }
    
    public func remove<T>(objects: [T]) -> Result<Void, Error> {
        for object in objects {
            guard let object = object as? NSManagedObject else { continue }
            self.deleteObject(object)
        }
        return Result(value: ())
    }
}
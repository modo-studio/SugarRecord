import Foundation
import RealmSwift
import Result

extension Realm: Context {
    
    /**
     Fetches objects and returns them using the provided request
     
     - parameter request: request to fetch the object
     
     - returns: request results and an error (in case of any)
     */
    public func fetch<T: Entity>(request: Request<T>) -> Result<[T], Error> {
        guard let E = T.self as? Object.Type else { return Result(error: .InvalidType) }
        var results = self.objects(E.self)
        if let predicate = request.predicate {
            results = results.filter(predicate)
        }
        if let sortDescriptor = request.sortDescriptor, key = sortDescriptor.key {
            results = results.sorted(key, ascending: sortDescriptor.ascending)
        }
        let array = results.toArray().map({$0 as Any as! T})
        return Result(value: array)
    }
    
    /**
     Inserts an object into the context
     
     - returns: inserted object and an error (incase of any)
     */
    public func insert<T: Entity>() -> Result<T, Error> {
        guard let E = T.self as? Object.Type else { return Result(error: .InvalidType) }
        let inserted = E.init()
        self.add(inserted)
        return Result(value: inserted as Any as! T)
    }
    
    /**
     Removes objets from the context
     
     - parameter objects: objects to be removed
     
     - returns: error (in case of any)
     */
    public func remove<T: Entity>(objects: [T]) -> Result<Void, Error> {
        self.beginWrite()
        self.delete(objects.map({$0.realm}).filter({$0 != nil}).map({$0!}))
        print("count \(objects.count)")
        do {
            try self.commitWrite()
            return Result(value: ())
        }
        catch {
            return Result(error: .WriteError)
        }
    }
}
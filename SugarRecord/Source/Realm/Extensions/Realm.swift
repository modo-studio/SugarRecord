import Foundation
import RealmSwift

extension Realm: Context {
    
    /**
     Fetches objects and returns them using the provided request.
     
     - parameter request: Request to fetch the objects.
     
     - throws: Throws an Error in case the object couldn't be fetched.
     
     - returns: Array with the results.
     */
    public func fetch<T: Entity>(request: Request<T>) throws -> [T] {
        guard let E = T.self as? Object.Type else { throw Error.InvalidType }
        var results = self.objects(E.self)
        if let predicate = request.predicate {
            results = results.filter(predicate)
        }
        if let sortDescriptor = request.sortDescriptor, key = sortDescriptor.key {
            results = results.sorted(key, ascending: sortDescriptor.ascending)
        }
        return results.toArray().map({$0 as Any as! T})
    }
    
    /**
     Inserts the entity to the Storage without saving it.
     
     - parameter entity: Entity to be added.
     
     - throws: Throws an Error.InvalidType or Internal Storage error in case the object couldn't be added.
     */
    public func insert<T: Entity>(entity: T) throws {
        guard let _ = T.self as? Object.Type else { throw Error.InvalidType }
        self.add(entity as! Object, update: true)
    }
    
    /**
     Creates an instance of type T and returns it.
     
     - throws: Throws an Error.InvalidType error in case of an usupported model type by the Storage.
     
     - returns: Created instance.
     */
    public func new<T: Entity>() throws -> T {
        guard let E = T.self as? Object.Type else { throw Error.InvalidType }
        return E.init() as! T
    }
    
    /**
     Removes objects from the context.
     
     - parameter objects: Objects to be removed.
     
     - throws: Throws an Error if the objects couldn't be removed.
     */
    public func remove<T: Entity>(objects: [T]) throws {
        self.delete(objects.map({$0.realm}).filter({$0 != nil}).map({$0!}))
    }
}
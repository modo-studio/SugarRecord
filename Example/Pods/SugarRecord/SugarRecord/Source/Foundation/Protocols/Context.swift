import Foundation

/**
 *  Context protocol. It works as a proxy for accessing the persistence solution.
 */
public protocol Context: Requestable {
    
     /**
     Fetches objects and returns them using the provided request.
     
     - parameter request: Request to fetch the objects.
     
     - throws: Throws an Error in case the object couldn't be fetched.
     
     - returns: Array with the results.
     */
    func fetch<T: Entity>(request: Request<T>) throws -> [T]
    

    /**
     Inserts the entity to the Storage without saving it.
     
     - parameter entity: Entity to be added.
     
     - throws: Throws an Error.InvalidType or Internal Storage error in case the object couldn't be added.
     */
    func insert<T: Entity>(entity: T) throws
    
     /**
     Initializes an instance of type T and returns it.
     
     - throws: Throws an Error.InvalidType error in case of an usupported model type by the Storage.
     
     - returns: Created instance.
     */
    func new<T: Entity>() throws -> T
    
    /**
     Initializes and saves an instance of type T and returns it.
     
     - throws: Throws an Error.InvalidType error in case of an unsupported model type by the Storage.
     
     - returns: Created instance.
     */
    func create<T: Entity>() throws -> T
    
    /**
     Removes objects from the context.
     
     - parameter objects: Objects to be removed.
     
     - throws: Throws an Error if the objects couldn't be removed.
     */
    func remove<T: Entity>(objects: [T]) throws
    
    /**
     Removes an object from the context.
     
     - parameter object: Object to be removed.
     
     - throws: Throws an Error if the object couldn't be removed.
     */
    func remove<T: Entity>(object: T) throws
}


// MARK: - Extension of Context implementing convenience methods.
public extension Context {
    
    /**
     Initializes and saves an instance of type T and returns it.
     
     - throws: Throws an Error.InvalidType error in case of an unsupported model type by the Storage.
     
     - returns: Created instance.
     */
    public func create<T: Entity>() throws -> T {
        let instance: T = try self.new()
        try self.insert(instance)
        return instance
    }
    
    /**
     Removes an object from the context.
     
     - parameter object: Object to be removed.
     
     - throws: Throws an Error if the object couldn't be removed.
     */
    public func remove<T: Entity>(object: T) throws {
        return try self.remove([object])
    }
}
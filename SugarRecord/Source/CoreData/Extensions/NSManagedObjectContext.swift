import Foundation
import CoreData


// MARK: - NSManagedObjectContext Extension (Context)

extension NSManagedObjectContext: Context {
    
    /**
     Fetches objects and returns them using the provided request.
     
     - parameter request: Request to fetch the objects.
     
     - throws: Throws an Error in case the object couldn't be fetched.
     
     - returns: Array with the results.
     */
    public func fetch<T: Entity>(request: Request<T>) throws -> [T] {
        guard let E = T.self as? NSManagedObject.Type else { throw Error.InvalidType }
        let fetchRequest: NSFetchRequest =  NSFetchRequest(entityName: E.entityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptor.map({[$0]})
        let results = try self.executeFetchRequest(fetchRequest)
        let typedResults = results.map({$0 as! T})
        return typedResults
    }
    
    /**
     Inserts the entity to the Storage without saving it.
     
     - parameter entity: Entity to be added.
     
     - throws: Throws an Error.InvalidType or Internal Storage error in case the object couldn't be added.
     */
    public func insert<T: Entity>(entity: T) throws {}
    
    /**
     Initializes an instance of type T and returns it.
     
     - throws: Throws an Error.InvalidType error in case of an usupported model type by the Storage.
     
     - returns: Created instance.
     */
    public func new<T: Entity>() throws -> T {
        guard let E = T.self as? NSManagedObject.Type else { throw Error.InvalidType }
        let object = NSEntityDescription.insertNewObjectForEntityForName(E.entityName, inManagedObjectContext: self)
        if let inserted = object as? T {
            return inserted
        }
        else {
            throw Error.InvalidType
        }
    }
    
    /**
     Removes objects from the context.
     
     - parameter objects: Objects to be removed.
     
     - throws: Throws an Error if the objects couldn't be removed.
     */
    public func remove<T: Entity>(objects: [T]) throws{
        for object in objects {
            guard let object = object as? NSManagedObject else { continue }
            self.deleteObject(object)
        }
    }
}


// MARK: - NSManagedObjectContext Extension (Utils)

extension NSManagedObjectContext {
    //NSManagedObjectContextWillSaveNotification
    
    func observe(inMainThread mainThread: Bool, saveNotification: (notification: NSNotification) -> Void) {
        let queue: NSOperationQueue = mainThread ? NSOperationQueue.mainQueue() : NSOperationQueue()
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: self, queue: queue, usingBlock: saveNotification)
    }
    
    func observeToGetPermanentIDsBeforeSaving() {
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextWillSaveNotification, object: self, queue: nil, usingBlock: { [weak self] (notification) in
            guard let s = self else { return }
            if s.insertedObjects.count == 0 { return }
            _ = try? s.obtainPermanentIDsForObjects(Array(s.insertedObjects))
        })
    }
}
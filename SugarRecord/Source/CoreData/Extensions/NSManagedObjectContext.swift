import Foundation
import CoreData


// MARK: - NSManagedObjectContext Extension (Context)

extension NSManagedObjectContext: Context {
    
    public func fetch<T: Entity>(request: Request<T>) throws -> [T] {
        guard let entity = T.self as? NSManagedObject.Type else { throw Error.InvalidType }
        let fetchRequest: NSFetchRequest =  NSFetchRequest(entityName: entity.entityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptor.map {[$0]}
        let results = try self.executeFetchRequest(fetchRequest)
        let typedResults = results.map {$0 as! T} 
        return typedResults
    }
    
    public func insert<T: Entity>(entity: T) throws {}
    
    public func new<T: Entity>() throws -> T {
        guard let entity = T.self as? NSManagedObject.Type else { throw Error.InvalidType }
        let object = NSEntityDescription.insertNewObjectForEntityForName(entity.entityName, inManagedObjectContext: self)
        if let inserted = object as? T {
            return inserted
        }
        else {
            throw Error.InvalidType
        }
    }
    
    public func remove<T: Entity>(objects: [T]) throws {
        for object in objects {
            guard let object = object as? NSManagedObject else { continue }
            self.deleteObject(object)
        }
    }
    
    public func removeAll() throws {
        throw Error.InvalidOperation("-removeAll not available in NSManagedObjectContext. Remove the store instead")
    }
    
}


// MARK: - NSManagedObjectContext Extension (Utils)

extension NSManagedObjectContext {
    
    func observe(inMainThread mainThread: Bool, saveNotification: (notification: NSNotification) -> Void) {
        let queue: NSOperationQueue = mainThread ? NSOperationQueue.mainQueue() : NSOperationQueue()
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: self, queue: queue, usingBlock: saveNotification)
    }
    
    func observeToGetPermanentIDsBeforeSaving() {
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextWillSaveNotification, object: self, queue: nil, usingBlock: { [weak self] (notification) in
            guard let s = self else {
                return
            }
            if s.insertedObjects.count == 0 {
                return
            }
            _ = try? s.obtainPermanentIDsForObjects(Array(s.insertedObjects))
        })
    }
    
}

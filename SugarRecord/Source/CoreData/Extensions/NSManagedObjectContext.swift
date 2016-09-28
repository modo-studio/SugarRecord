import Foundation
import CoreData


// MARK: - NSManagedObjectContext Extension (Context)

extension NSManagedObjectContext: Context {
    
    public func fetch<T: Entity>(_ request: FetchRequest<T>) throws -> [T] {
        guard let entity = T.self as? NSManagedObject.Type else { throw StorageError.invalidType }
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptor.map {[$0]}
        fetchRequest.fetchOffset = request.fetchOffset
        fetchRequest.fetchLimit = request.fetchLimit
        let results = try self.fetch(fetchRequest)
        let typedResults = results.map {$0 as! T} 
        return typedResults
    }
    
    public func insert<T: Entity>(_ entity: T) throws {}
    
    public func new<T: Entity>() throws -> T {
        guard let entity = T.self as? NSManagedObject.Type else { throw StorageError.invalidType }
        let object = NSEntityDescription.insertNewObject(forEntityName: entity.entityName, into: self)
        if let inserted = object as? T {
            return inserted
        }
        else {
            throw StorageError.invalidType
        }
    }
    
    public func remove<T: Entity>(_ objects: [T]) throws {
        for object in objects {
            guard let object = object as? NSManagedObject else { continue }
            self.delete(object)
        }
    }
    
    public func removeAll() throws {
        throw StorageError.invalidOperation("-removeAll not available in NSManagedObjectContext. Remove the store instead")
    }
    
}


// MARK: - NSManagedObjectContext Extension (Utils)

extension NSManagedObjectContext {
    
    func observe(inMainThread mainThread: Bool, saveNotification: @escaping (_ notification: Notification) -> Void) {
        let queue: OperationQueue = mainThread ? OperationQueue.main : OperationQueue()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: self, queue: queue, using: saveNotification)
    }
    
    func observeToGetPermanentIDsBeforeSaving() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextWillSave, object: self, queue: nil, using: { [weak self] (notification) in
            guard let s = self else {
                return
            }
            if s.insertedObjects.count == 0 {
                return
            }
            _ = try? s.obtainPermanentIDs(for: Array(s.insertedObjects))
        })
    }
    
}

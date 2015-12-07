import Foundation
import CoreData
import Result


// MARK: - NSManagedObjectContext Extension (Context)

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
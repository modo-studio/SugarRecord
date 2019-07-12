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
    
    public func fetchOne<T: Entity>(_ request: FetchRequest<T>) throws -> T? {
        guard let entity = T.self as? NSManagedObject.Type else { throw StorageError.invalidType }
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptor.map {[$0]}
        fetchRequest.fetchOffset = request.fetchOffset
        fetchRequest.fetchLimit = 1
        
        if let results = try? self.fetch(fetchRequest), results.count > 0, let item = results.first as? T {
            return item
        }
        
        return nil
    }
    
    public func query<T: Entity>(_ request: FetchRequest<T>, attributes: [String]) throws -> [[String: Any]] {
        guard let entity = T.self as? NSManagedObject.Type else { throw StorageError.invalidType }
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptor.map {[$0]}
        fetchRequest.fetchOffset = request.fetchOffset
        fetchRequest.fetchLimit = request.fetchLimit
        
        fetchRequest.propertiesToFetch = attributes
        fetchRequest.resultType = .dictionaryResultType
        
        let results = try self.fetch(fetchRequest)
        let typedResults = results.compactMap { $0 as? [String: Any] }
        return typedResults
    }
    
    public func query<T: Entity>(_ request: FetchRequest<T>, attribute: String) throws -> [String]? {
        guard let entity = T.self as? NSManagedObject.Type else { throw StorageError.invalidType }
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptor.map {[$0]}
        fetchRequest.fetchOffset = request.fetchOffset
        fetchRequest.fetchLimit = request.fetchLimit
        
        fetchRequest.propertiesToFetch = [attribute]
        fetchRequest.resultType = .dictionaryResultType
        
        let results = try self.fetch(fetchRequest)
        
        var elements = [String]()
        results.compactMap { $0 as? [String: Any] }.forEach {
            if let value = $0[attribute] as? String {
                elements.append(value)
            }
        }
        
        return elements
    }
    
    public func querySet<T: Entity>(_ request: FetchRequest<T>, attribute: String) throws -> Set<String>? {
        guard let entity = T.self as? NSManagedObject.Type else { throw StorageError.invalidType }
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptor.map {[$0]}
        fetchRequest.fetchOffset = request.fetchOffset
        fetchRequest.fetchLimit = request.fetchLimit
        
        fetchRequest.propertiesToFetch = [attribute]
        fetchRequest.resultType = .dictionaryResultType
        
        let results = try self.fetch(fetchRequest)
        
        var ids = Set<String>()
        
        if let currentResults = results as? [[String: Any]] {
            for item in currentResults {
                if let id = item[attribute] as? String {
                    ids.insert(id)
                }
            }
        }
        
        return ids
    }
    
    public func queryOne<T: Entity>(_ request: FetchRequest<T>, attributes: [String]) throws -> [String: Any]? {
        guard let entity = T.self as? NSManagedObject.Type else { throw StorageError.invalidType }
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptor.map {[$0]}
        fetchRequest.fetchOffset = request.fetchOffset
        fetchRequest.fetchLimit = 1
        
        fetchRequest.propertiesToFetch = attributes
        fetchRequest.resultType = .dictionaryResultType
        
        let results = try self.fetch(fetchRequest)
        let typedResults = results.compactMap { $0 as? [String: Any] }
        return typedResults.first
    }
    
    public func count<T: Entity>(_ request: FetchRequest<T>) -> Int {
        guard let entity = T.self as? NSManagedObject.Type else { return 0 }
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: entity.entityName)
        fetchRequest.predicate = request.predicate
        
        if let count = try? self.count(for: fetchRequest) {
            return count
        }
        
        return 0
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
    
    public func saveToPersistentStore(_ completion: ((Swift.Result<Any?, Error>) -> Void)? = nil) {
        
        self.performAndWait {
            do {
                try self.save()
                
                if let parentContext = self.parent {
                    parentContext.saveToPersistentStore(completion)
                } else {
                    DispatchQueue.main.async {
                        completion?(.success(nil))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                  completion?(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Batch Actions
    public func batchUpdate(entityName: String, propertiesToUpdate: [AnyHashable : Any]?, predicate: NSPredicate?) {
        let request = NSBatchUpdateRequest(entityName: entityName)
        request.propertiesToUpdate = propertiesToUpdate
        request.resultType = .updatedObjectsCountResultType
        request.predicate = predicate
        
        _ = try? self.execute(request)
    }
    
    public func batchDelete(entityName: String, predicate: NSPredicate?) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetch.predicate = predicate
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        _ = try? self.execute(request)
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

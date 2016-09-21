import Foundation
import RealmSwift

open class RealmDefaultStorage: Storage {
    
    // MARK: - Attributes
    
    fileprivate let configuration: Realm.Configuration?
    
    
    ///  MARK: - Init
    
    public convenience init(configuration: Realm.Configuration? = nil) {
        self.init(configuration: configuration, versionController: VersionController())
    }
    
    internal init(configuration: Realm.Configuration? = nil, versionController: VersionController) {
        self.configuration = configuration
        #if DEBUG
        versionController.check()
        #endif
    }
    
    
    // MARK: - Storage
    
    open var description: String { return "RealmDefaultStorage" }
    
    open var type: StorageType { return .realm }
    
    open var mainContext: Context! {
        if let configuration = self.configuration {
            return try? Realm(configuration: configuration)
        }
        else {
            return try? Realm()
        }
    }
    
    open var saveContext: Context! {
        if let configuration = self.configuration {
            return try? Realm(configuration: configuration)
        }
        else {
            return try? Realm()
        }
    }
    
    open var memoryContext: Context! {
        return try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MemoryRealm"))
    }
    
    open func removeStore() throws {
        if let url = try Realm().configuration.fileURL {
            try FileManager.default.removeItem(at: url)
        }
    }

    open func operation<T>(_ operation: @escaping (_ context: Context, _ save: @escaping () -> Void) throws -> T) throws -> T {
        let context: Realm = self.saveContext as! Realm
        context.beginWrite()
        var save: Bool = false
        var _error: Swift.Error!
        
        var returnedObject: T!
        do {
            returnedObject = try operation(context, { () -> Void in
                defer {
                    save = true
                }
                do {
                    try context.commitWrite()
                }
                catch {
                    context.cancelWrite()
                    _error = error
                }
            })
        }
        catch {
            _error = error
        }
        if !save {
            context.cancelWrite()
        }
        if let error = _error {
            throw error
        }
        
        return returnedObject

    }
    
    open func observable<T: Object>(_ request: FetchRequest<T>) -> RequestObservable<T> {
        return RealmObservable(request: request, realm: self.mainContext as! Realm)
    }
    
}

import Foundation
import RealmSwift

public class RealmDefaultStorage: Storage {
    
    // MARK: - Attributes
    
    private let configuration: Realm.Configuration?
    
    
    ///  MARK: - Init
    
    public init(configuration: Realm.Configuration? = nil) {
        self.configuration = configuration
    }
    
    
    // MARK: - Storage
    
    public var description: String { return "RealmDefaultStorage" }
    
    public var type: StorageType { return .Realm }
    
    public var mainContext: Context! {
        if let configuration = self.configuration {
            return try? Realm(configuration: configuration)
        }
        else {
            return try? Realm()
        }
    }
    
    public var saveContext: Context! {
        if let configuration = self.configuration {
            return try? Realm(configuration: configuration)
        }
        else {
            return try? Realm()
        }
    }
    
    public var memoryContext: Context! {
        return try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MemoryRealm"))
    }
    
    public func removeStore() throws {
        if let url = try Realm().configuration.fileURL {
            try NSFileManager.defaultManager().removeItemAtURL(url)
        }
    }

    public func operation(operation: (context: Context, save: () -> Void) throws -> Void) throws {
        let context: Realm = self.saveContext as! Realm
        context.beginWrite()
        var save: Bool = false
        var _error: ErrorType!
        do {
            try operation(context: context, save: { () -> Void in
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
    }
    
    public func observable<T: Object>(request: Request<T>) -> Observable<T> {
        return RealmObservable(request: request, realm: self.mainContext as! Realm)
    }
    
}

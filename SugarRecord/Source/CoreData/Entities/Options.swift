import Foundation
import CoreData

// MARK: - CoreData.Options

public extension CoreData {
    
    /**
     NSPersistantStore initialization options
     
     - Default:      Default options
     - Migration: Automatic migration options
     */
    public enum Options {
        case Default
        case Migration
    
        func dict() -> [NSObject: AnyObject] {
            switch self {
            case .Default:
                var sqliteOptions: [String: String] = [String: String] ()
                sqliteOptions["WAL"] = "journal_mode"
                var options: [NSObject: AnyObject] = [NSObject: AnyObject] ()
                options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(bool: true)
                options[NSInferMappingModelAutomaticallyOption] = NSNumber(bool: false)
                options[NSSQLitePragmasOption] = sqliteOptions
                return options
            case .Migration:
                var sqliteOptions: [String: String] = [String: String] ()
                sqliteOptions["WAL"] = "journal_mode"
                var options: [NSObject: AnyObject] = [NSObject: AnyObject] ()
                options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(bool: true)
                options[NSInferMappingModelAutomaticallyOption] = NSNumber(bool: true)
                options[NSSQLitePragmasOption] = sqliteOptions
                return options
            }
        }
        
    }
}

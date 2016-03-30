import Foundation
import CoreData

public extension CoreData {

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

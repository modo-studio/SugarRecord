import Foundation
import CoreData

public extension CoreData {

    public enum Options {
        case Default
        case Migration
    
        func dict() -> [String: AnyObject] {
            switch self {
            case .Default:
                var sqliteOptions: [String: String] = [String: String] ()
                sqliteOptions["journal_mode"] = "DELETE"
                var options: [String: AnyObject] = [String: AnyObject] ()
                options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(value: true)
                options[NSInferMappingModelAutomaticallyOption] = NSNumber(value: false)
                options[NSSQLitePragmasOption] = sqliteOptions as AnyObject?
                return options
            case .Migration:
                var sqliteOptions: [String: String] = [String: String] ()
                sqliteOptions["journal_mode"] = "DELETE"
                var options: [String: AnyObject] = [String: AnyObject] ()
                options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(value: true)
                options[NSInferMappingModelAutomaticallyOption] = NSNumber(value: true)
                options[NSSQLitePragmasOption] = sqliteOptions as AnyObject?
                return options
            }
        }
        
    }
}

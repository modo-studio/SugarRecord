import Foundation
import CoreData

public enum CoreDataOptions {
    
    case basic
    case migration
    
    func dict() -> [String: AnyObject] {
        switch self {
        case .basic:
            var sqliteOptions: [String: String] = [String: String] ()
            sqliteOptions["journal_mode"] = "DELETE"
            var options: [String: AnyObject] = [String: AnyObject] ()
            options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(value: true)
            options[NSInferMappingModelAutomaticallyOption] = NSNumber(value: false)
            options[NSSQLitePragmasOption] = sqliteOptions as AnyObject?
            return options
        case .migration:
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

import Foundation
import CoreData

// MARK: - CoreData.Options

extension CoreData {
    
    struct Options {
        
        static var main: [NSObject: AnyObject] {
            get {
                var sqliteOptions: [String: String] = [String: String] ()
                sqliteOptions["WAL"] = "journal_mode"
                var options: [NSObject: AnyObject] = [NSObject: AnyObject] ()
                options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(bool: true)
                options[NSInferMappingModelAutomaticallyOption] = NSNumber(bool: false)
                options[NSSQLitePragmasOption] = sqliteOptions
                return options
            }
        }
        
        static var migration: [NSObject: AnyObject] {
            get {
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
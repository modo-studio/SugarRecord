import Foundation
import RealmSwift

class RealmBasicObject: Object {
    
    // MARK: - Attributes
    
    dynamic var date: NSDate = NSDate()
    dynamic var name: String = ""
    
    
    // MARK: - PrimaryKey
    
    internal override class func primaryKey() -> String? {
        return "name"
    }
    
}
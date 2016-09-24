import Foundation
import RealmSwift

class RealmBasicObject: Object {
    
    // MARK: - Attributes
    
    dynamic var date: Date = Date()
    dynamic var name: String = ""
    
    
    // MARK: - PrimaryKey
    
    internal override class func primaryKey() -> String? {
        return "name"
    }
    
}

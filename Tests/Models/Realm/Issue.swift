import Foundation
import RealmSwift

@testable import SugarRecord

class Issue: Object {
    
    // MARK: - Attributes
    
    dynamic var name: String = ""
    dynamic var closed: Bool = false
    dynamic var id: String = ""
    
    
    // MARK: - Object
    
    internal override class func primaryKey() -> String? {
        return "id"
    }
    
    
    // MARK: - Relationships
    
    dynamic var repository: Repository?
}
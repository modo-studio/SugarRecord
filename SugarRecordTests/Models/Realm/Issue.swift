import Foundation
import RealmSwift

@testable import SugarRecordRealm

class Issue: Object {
    
    // MARK: - Attributes
    
    dynamic var name: String = ""
    dynamic var closed: Bool = false
    
    
    // MARK: - Relationships
    
    dynamic var repository: Repository?
}
import Foundation
import RealmSwift

@testable import SugarRecordRealm

class Repository: Object {
    
    // MARK: - Attributes
    
    dynamic var name: String = ""
    dynamic var organization: String = ""
    
    
    // MARK: - Relationships
        
    var issues: [Issue] {
        return linkingObjects(Issue.self, forProperty: "repository")
    }
}
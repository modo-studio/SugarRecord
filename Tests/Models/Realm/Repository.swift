import Foundation
import RealmSwift

@testable import SugarRecord

class Repository: Object {
    
    // MARK: - Attributes
    
    dynamic var name: String = ""
    dynamic var organization: String = ""
    
    
    // MARK: - Relationships
    
    let issues = LinkingObjects(fromType: Issue.self, property: "repository")

}
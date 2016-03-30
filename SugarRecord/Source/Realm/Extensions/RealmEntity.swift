import Foundation
import RealmSwift

extension Entity {
    
    /// Realm object wrapped by the Entity
    var realm: Object? {
        get {
            return (self as? Object)
        }
    }
    
}

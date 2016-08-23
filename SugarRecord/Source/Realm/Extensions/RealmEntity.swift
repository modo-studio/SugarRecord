import Foundation
import RealmSwift

extension Entity {
    
    /// Realm object wrapped by the Entity
    var realm: RealmSwift.Object? {
        get {
            return (self as? RealmSwift.Object)
        }
    }
    
}

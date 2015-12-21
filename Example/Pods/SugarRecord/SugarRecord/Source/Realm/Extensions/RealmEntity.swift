import Foundation
import RealmSwift

// MARK: - Entity extension to access proxied elements by entity. In this case we want to get the proxied realm Object in order to be used by the context
extension Entity {
    
    /// Realm object wrapped by the Entity
    var realm: Object? {
        get {
            return (self as? Object)
        }
    }
    
}
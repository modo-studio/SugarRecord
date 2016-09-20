import Foundation
import CoreData

class BasicObject: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
}

extension BasicObject {
    
    @NSManaged var date: Date?
    @NSManaged var name: String?
    
}

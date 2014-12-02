import Foundation
import CoreData

@objc(CoreDataObject)
class CoreDataObject: NSManagedObject {

    @NSManaged var age: NSDecimalNumber
    @NSManaged var birth: NSDate
    @NSManaged var city: String
    @NSManaged var email: String
    @NSManaged var name: String

}

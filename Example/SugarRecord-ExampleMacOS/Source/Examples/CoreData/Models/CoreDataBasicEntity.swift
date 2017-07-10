import Foundation

class CoreDataBasicEntity {
    
    // MARK: - Attributes
    
    let dateString: String
    let name: String
    
    // MARK: - Init 
    
    init(object: BasicObject) {
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = DateFormatter.Style.short
        dateFormater.dateStyle = DateFormatter.Style.short
        self.dateString = dateFormater.string(from: object.date! as Date)
        self.name = object.name!
    }
}

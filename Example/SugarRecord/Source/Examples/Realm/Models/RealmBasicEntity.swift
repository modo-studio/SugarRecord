import Foundation

class RealmBasicEntity {
    
    // MARK: - Attributes
    
    let dateString: String
    let name: String
    
    
    // MARK: - Init
    
    init(object: RealmBasicObject) {
        let dateFormater = NSDateFormatter()
        dateFormater.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormater.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateString = dateFormater.stringFromDate(object.date)
        self.name = object.name
    }
    
}

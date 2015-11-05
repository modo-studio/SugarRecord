import Foundation


// MARK: Request extension (NSPredicateConvertible)

extension Request: NSPredicateConvertible {
    
    init(predicate: NSPredicate) {
        self = Request(predicate: predicate)
    }
}


// MARK: Request extension (NSSortDescriptorConvertible)

extension Request: NSSortDescriptorConvertible {
    
    init(sortDescriptor: NSSortDescriptor) {
        self = Request(sortDescriptor: sortDescriptor)
    }
}
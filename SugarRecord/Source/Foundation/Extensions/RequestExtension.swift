import Foundation


// MARK: Request extension (NSPredicateConvertible)

extension Request: NSPredicateConvertible {
    
    public init(predicate: NSPredicate) {
        self = Request(predicate: predicate)
    }
}


// MARK: Request extension (NSSortDescriptorConvertible)

extension Request: NSSortDescriptorConvertible {
    
    public init(sortDescriptor: NSSortDescriptor) {
        self = Request(sortDescriptor: sortDescriptor)
    }

}

import Foundation


// MARK: Request extension (NSPredicateConvertible)

extension FetchRequest: NSPredicateConvertible {
    
    public init(predicate: NSPredicate) {
        self = FetchRequest(predicate: predicate)
    }
}


// MARK: Request extension (NSSortDescriptorConvertible)

extension FetchRequest: NSSortDescriptorConvertible {
    
    public init(sortDescriptor: NSSortDescriptor) {
        self = FetchRequest(sortDescriptor: sortDescriptor)
    }

}

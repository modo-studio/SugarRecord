import Foundation


// MARK: Request extension (NSPredicateConvertible)

extension Request: NSPredicateConvertible {
    
    public init(predicate: Predicate) {
        self = Request(predicate: predicate)
    }
}


// MARK: Request extension (NSSortDescriptorConvertible)

extension Request: NSSortDescriptorConvertible {
    
    public init(sortDescriptor: SortDescriptor) {
        self = Request(sortDescriptor: sortDescriptor)
    }

}

import Foundation


// MARK: Request extension (NSPredicateConvertible)

extension Request: NSPredicateConvertible {
    
    init(predicate: NSPredicate) {
        Request(predicate: predicate)
    }
    
    func predicate() -> NSPredicate {
        return self.predicate ?? NSPredicate(format: "")
    }
}


// MARK: Request extension (NSSortDescriptorConvertible)

extension Request: NSSortDescriptorConvertible {
    
    init(sortDescriptor: NSSortDescriptor) {
        Request(sortDescriptor: sortDescriptor)
    }
    
    func sortDescriptor() -> NSSortDescriptor {
        return self.sortDescriptor ?? NSSortDescriptor()
    }
}
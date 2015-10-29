import Foundation


protocol NSPredicateConvertible {
    
    init(predicate: NSPredicate)
    func predicate() -> NSPredicate
}
import Foundation

public protocol NSPredicateConvertible {
    
    init(predicate: NSPredicate)    
    var predicate: NSPredicate? { get }

}

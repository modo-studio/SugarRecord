import Foundation

/**
 *  Protocol that defines that the entity that conforms it contains a predicate
 */
public protocol NSPredicateConvertible {
    
    /**
     Initializes the entity with a predicate
     
     - parameter predicate: predicate
     
     - returns: initialized NSPredicateConvertible entity
     */
    init(predicate: NSPredicate)
    
    /// Predicate
    var predicate: NSPredicate? { get }

}

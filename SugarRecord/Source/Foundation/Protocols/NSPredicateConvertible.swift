import Foundation

public protocol NSPredicateConvertible {
    
    init(predicate: Predicate)    
    var predicate: Predicate? { get }

}

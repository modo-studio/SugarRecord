import Foundation

protocol NSPredicateConvertible {
    init(predicate: NSPredicate)
    var predicate: NSPredicate? { get }
}
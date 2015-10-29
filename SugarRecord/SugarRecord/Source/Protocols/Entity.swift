import Foundation

/**
 *  Protocol that represents an store entity
 */
public protocol Entity {
    
    /// Entity name
    static var entityName: String { get }
}
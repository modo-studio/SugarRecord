import Foundation

/**
 *  Protocol that defines that the entity that conforms it contains a sort descriptor
 */
public protocol NSSortDescriptorConvertible {
    
    /**
     Initializes the entity with a sort descriptor
     
     - parameter sortDescriptor: sort descriptor
     
     - returns: initialized NSSortDescriptorConvertible
     */
    init(sortDescriptor: NSSortDescriptor)
    
    /// Sort descriptor
    var sortDescriptor: NSSortDescriptor? { get }

}

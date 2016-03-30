import Foundation

public protocol NSSortDescriptorConvertible {
    
    init(sortDescriptor: NSSortDescriptor)    
    var sortDescriptor: NSSortDescriptor? { get }

}

import Foundation

public protocol NSSortDescriptorConvertible {
    
    init(sortDescriptor: SortDescriptor)    
    var sortDescriptor: SortDescriptor? { get }

}

import Foundation

protocol NSSortDescriptorConvertible {
    init(sortDescriptor: NSSortDescriptor)
    var sortDescriptor: NSSortDescriptor? { get }
}
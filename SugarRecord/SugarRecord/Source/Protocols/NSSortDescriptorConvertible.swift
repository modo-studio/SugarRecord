import Foundation

protocol NSSortDescriptorConvertible {
    init(sortDescriptor: NSSortDescriptor)
    func sortDescriptor() -> NSSortDescriptor
}
import Foundation

internal enum CoreDataChange<T> {
    
    // TODO - Test
    
    case Update(T)
    case Insert(T)
    case Delete(T)
    
    func object() -> T {
        switch self {
        case .Update(let object): return object
        case .Delete(let object): return object
        case .Insert(let object): return object
        }
    }
    
    func isDeletion() -> Bool {
        switch self {
        case .Insert(_): return true
        default: return false
        }
    }
    
    func isUpdate() -> Bool {
        switch self {
        case .Update(_): return true
        default: return false
        }
    }
    
    func isInsertion() -> Bool {
        switch self {
        case .Insert(_): return true
        default: return false
        }
    }
}

import Foundation

internal enum CoreDataChange<T> {
    
    case Update(Int, T)
    case Insert(Int, T)
    case Delete(Int, T)
    
    func object() -> T {
        switch self {
        case .Update(_, let object): return object
        case .Delete(_, let object): return object
        case .Insert(_, let object): return object
        }
    }
    
    func index() -> Int {
        switch self {
        case .Update(let index, _): return index
        case .Delete(let index, _): return index
        case .Insert(let index, _): return index
        }
    }
    
    func isDeletion() -> Bool {
        switch self {
        case .Delete(_): return true
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

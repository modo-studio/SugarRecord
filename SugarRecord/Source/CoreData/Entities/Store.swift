import CoreData
import Foundation

public extension CoreData {
    
    public enum Store {
        
        case Named(String)
        case URL(NSURL)
        
        public func path() -> NSURL {
            switch self {
            case .URL(let url): return url
            case .Named(let name):
                return NSURL(fileURLWithPath: documentsDirectory()).URLByAppendingPathComponent(name)
            }
        }
        
    }
}


// MARK: - Store extension (CustomStringConvertible)

extension CoreData.Store: CustomStringConvertible {
    
    public var description: String {
        get {
            return "CoreData Store: \(self.path())"
        }
    }
    
}


// MARK: - Store Extension (Equatable)

extension CoreData.Store: Equatable {}

public func == (lhs: CoreData.Store, rhs: CoreData.Store) -> Bool {
    return lhs.path() == rhs.path()
}

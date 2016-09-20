import CoreData
import Foundation

public extension CoreData {
    
    public enum Store {
        
        case Named(String)
        case URL(URL)
        
        public func path() -> URL {
            switch self {
            case .URL(let url): return url
            case .Named(let name):
                return Foundation.URL(fileURLWithPath: documentsDirectory()).appendingPathComponent(name)
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

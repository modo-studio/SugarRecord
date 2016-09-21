import CoreData
import Foundation

public enum CoreDataStore {
    
    case named(String)
    case url(URL)
    
    public func path() -> URL {
        switch self {
        case .url(let url): return url
        case .named(let name):
            return URL(fileURLWithPath: documentsDirectory()).appendingPathComponent(name)
        }
    }
    
}

// MARK: - Store extension (CustomStringConvertible)

extension CoreDataStore: CustomStringConvertible {
    
    public var description: String {
        get {
            return "CoreData Store: \(self.path())"
        }
    }
    
}


// MARK: - Store Extension (Equatable)

extension CoreDataStore: Equatable {}

public func == (lhs: CoreDataStore, rhs: CoreDataStore) -> Bool {
    return lhs.path() == rhs.path()
}

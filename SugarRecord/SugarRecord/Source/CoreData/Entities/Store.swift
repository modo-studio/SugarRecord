import CoreData
import Foundation

// MARK: - CoreData.Store

public extension CoreData {
    
    /**
     It represents a reference to the store
     
     - Named: Store with the provided name will be used (internally the storage decides the folder, usually Documents)
     - URL: Store with on the provided path will be used
     */
    public enum Store {
        case Named(String)
        case URL(NSURL)
        
        /**
         Returns the store path
         
         - returns: store path
         */
        public func path() -> NSURL {
            switch self {
            case .URL(let url): return url
            case .Named(let name):
                return NSURL(fileURLWithPath: documentsDirectory()).URLByAppendingPathComponent(name)
            }
        }
    }
}

func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths[0]
}
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
        func path() -> NSURL {
            switch self {
            case .URL(let url): return url
            case .Named(let _):
                //FIXME
                return NSURL()
            }
        }
    }
    
}
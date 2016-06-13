import Foundation

public enum ObservableChange<T> {
    case Initial([T])
    case Update(deletions: [Int], insertions: [(index: Int, element: T)], modifications: [(index: Int, element: T)])
    case Error(NSError)
}

public class RequestObservable<T: Entity>: NSObject {
    
    // MARK: - Attributes
    
    internal let request: Request<T>
    
    
    // MARK: - Init
    
    internal init(request: Request<T>) {
        self.request = request
    }
    
    
    // MARK: - Public
    
    public func observe(closure: ObservableChange<T> -> Void) {
        assertionFailure("The observe method must be overriden")
    }
    
    
    // MARK: - Internal
    
    internal func dispose() {
        assertionFailure("The observe method must be overriden")
    }
    
}

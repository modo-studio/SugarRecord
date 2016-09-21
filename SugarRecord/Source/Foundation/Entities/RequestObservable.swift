import Foundation

public enum ObservableChange<T> {
    case initial([T])
    case update(deletions: [Int], insertions: [(index: Int, element: T)], modifications: [(index: Int, element: T)])
    case error(Error)
}

open class RequestObservable<T: Entity>: NSObject {
    
    // MARK: - Attributes
    
    internal let request: FetchRequest<T>
    
    
    // MARK: - Init
    
    internal init(request: FetchRequest<T>) {
        self.request = request
    }
    
    
    // MARK: - Public
    
    open func observe(_ closure: @escaping (ObservableChange<T>) -> Void) {
        assertionFailure("The observe method must be overriden")
    }
    
    
    // MARK: - Internal
    
    internal func dispose() {
        assertionFailure("The observe method must be overriden")
    }
    
}

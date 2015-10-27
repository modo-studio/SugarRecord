import Foundation
import ReactiveCocoa

public struct Request<T> {
    
    // MARK: - Attributes
    
    let sortDescriptor: NSSortDescriptor?
    let predicate: NSPredicate?
    
    
    // MARK: - Init
    
    init(sortDescriptor: NSSortDescriptor? = nil, predicate: NSPredicate? = nil) {
        self.sortDescriptor = sortDescriptor
        self.predicate = predicate
    }
    
    
    // MARK: - Public
    
    func inThread(thread: Thread) -> SignalProducer<T, RequestError> {
        return fetch(self, thread: thread)
    }
    
    func inStack(stack: Stack) -> SignalProducer<T, RequestError> {
        return fetch(self, stack: stack)
    }
    
    
    // MARK: - Internal
    
    func request(withPredicate predicate: NSPredicate) -> Request<T> {
        return Request<T>(sortDescriptor: sortDescriptor, predicate: predicate)
    }
    
    func request(withSortDescriptor sortDescriptor: NSSortDescriptor) -> Request<T> {
        return Request<T>(sortDescriptor: sortDescriptor, predicate: predicate)
    }
}


// MARK: - Private funcs

private func fetch<T>(request: Request<T>, thread: Thread) -> SignalProducer<T, RequestError> {
    
    // Requet
    
    //TODO
}

private func fetch<T>(request: Request<T>, stack: Stack) -> SignalProducer<T, RequestError> {
    //TODO
}
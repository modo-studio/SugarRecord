import Foundation
import ReactiveCocoa

/**
 *  Protol that defines the Reactive interface of an Storage
 */
public protocol ReactiveStorage {
    
    typealias Saver = () -> Void
    
    // MARK: - Operations
    
    /**
    Executes the given operation in the provided Queue.
    
    - parameter queue:     Queue where the operation will be executed.
    - parameter operation: Operation to be executed. Context must be used to save your changes in and the save() closure must be called in order to get the changes persisted in the storage.
    
    - returns: SignalProducer that executes the action.
    */
    func rac_operation(queue queue: Queue, operation: (context: Context, save: Saver) -> Void) -> SignalProducer<Void, NoError>
    
    /**
     Executes the given operation in a background Queue.
     
     - parameter operation: Operation to be executed. Context must be used to save your changes in and the save() closure must be called in order to get the changes persisted in the storage.
     
     - returns: SignalProducer that executes the action.
     */
    func rac_operation(operation: (context: Context, save: Saver) -> Void) -> SignalProducer<Void, NoError>
}


public extension ReactiveStorage where Self: Storage {
    
    // MARK: - Operation
    
    /**
    Executes the given operation in the provided Queue.
    
    - parameter queue:     Queue where the operation will be executed.
    - parameter operation: Operation to be executed. Context must be used to save your changes in and the save() closure must be called in order to get the changes persisted in the storage.
    
    - returns: SignalProducer that executes the action.
    */
    func rac_operation(queue queue: Queue, operation: (context: Context, save: Saver) -> Void) -> SignalProducer<Void, NoError> {
        return SignalProducer { (observer, disposable) in
            self.operation(queue: queue, operation: operation) { () -> Void in
                observer.sendCompleted()
            }
        }
    }
    
    /**
     Executes the given operation in a background Queue.
     
     - parameter operation: Operation to be executed. Context must be used to save your changes in and the save() closure must be called in order to get the changes persisted in the storage.
     
     - returns: SignalProducer that executes the action.
     */
    func rac_operation(operation: (context: Context, save: Saver) -> Void) -> SignalProducer<Void, NoError> {
        return SignalProducer { (observer, disposable) in
            self.operation(operation, completed: { () -> Void in
                observer.sendCompleted()
            })
        }
    }
}
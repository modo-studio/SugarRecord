import Foundation
import ReactiveCocoa
import Result

public extension ReactiveStorage where Self: Storage {
    
    // MARK: - Operation
    
    /**
    Executes the given operation in the provided Queue.
    
    - parameter queue:     Queue where the operation will be executed.
    - parameter operation: Operation to be executed. Context must be used to save your changes in and the save() closure must be called in order to get the changes persisted in the storage.
    
    - returns: SignalProducer that executes the action.
    */
    func rac_operation(op: (context: Context, save: Saver) -> Void) -> SignalProducer<Void, NoError> {
        return SignalProducer { (observer, disposable) in
            self.operation { (context, saver) in
                op(context: context, save: saver)
                observer.sendCompleted()
            }
        }
    }
    
    /**
     Executes the given operation in a background thread.
     
     - parameter operation: Operation to be executed. Context must be used to save your changes in and the save() closure must be called in order to get the changes persisted in the storage.
     
     - returns: SignalProducer that executes the action.
     */
    func rac_backgroundOperation(op: (context: Context, save: Saver) -> Void) -> SignalProducer<Void, NoError> {
        return SignalProducer { (observer, disposable) in
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                self.operation { (context, saver) in
                    op(context: context, save: saver)
                    observer.sendCompleted()
                }
            }
        }
    }
    
    /**
     Executes a background fetch mapping the response into a PONSO thread safe entity.
     
     - parameter request: Request to be executed.
     - parameter mapper:  Mapper.
     
     - returns: SignalProducer that executes the action.
     */
    func rac_backgroundFetch<T: Entity, U>(request: Request<T>, mapper: T -> U) -> SignalProducer<[U], Error> {
        let producer: SignalProducer<[T], Error> = SignalProducer { (observer, disposable) in
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                do {
                    let results = try self.saveContext.fetch(request)
                    observer.sendNext(results)
                    observer.sendCompleted()
                }
                catch {
                    if let error = error as? Error {
                        observer.sendFailed(error)
                    }
                    else {
                        observer.sendNext([])
                        observer.sendCompleted()
                    }
                }
            }
        }
        return producer.map({$0.map(mapper)}).observeOn(UIScheduler())
    }
    
    /**
     Executes a request.
     
     - parameter request: Request to be executed.
     
     - returns: SignalProducer that executes the action.
     */
    func rac_fetch<T: Entity>(request: Request<T>) -> SignalProducer<[T], Error> {
        return SignalProducer { (observer, disposable) in
            do {
                try observer.sendNext(self.fetch(request))
                observer.sendCompleted()
            }
            catch  {
                if let error = error as? Error {
                    observer.sendFailed(error)
                }
                else {
                    observer.sendNext([])
                    observer.sendCompleted()
                }
            }
        }
    }
    
}
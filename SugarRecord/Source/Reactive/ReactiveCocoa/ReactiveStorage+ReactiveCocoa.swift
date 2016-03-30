import Foundation
import ReactiveCocoa
import Result

public extension ReactiveStorage where Self: Storage {
    
    // MARK: - Operation
    
    func rac_operation(op: (context: Context, save: () -> Void) -> Void) -> SignalProducer<Void, Error> {
        return SignalProducer { (observer, disposable) in
            self.operation { (context, saver) in
                op(context: context, save: { 
                    do {
                        try saver()
                    }
                    catch {
                        observer.sendFailed(Error.Store(error))
                    }
                })
                observer.sendCompleted()
            }
        }
    }
    
    func rac_backgroundOperation(op: (context: Context, save: () -> Void) -> Void) -> SignalProducer<Void, Error> {
        return SignalProducer { (observer, disposable) in
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                self.operation { (context, saver) in
                    op(context: context, save: {
                        do {
                            try saver()
                        }
                        catch {
                            observer.sendFailed(Error.Store(error))
                        }
                    })
                    observer.sendCompleted()
                }
            }
        }
    }
    
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
        return producer.map { $0.map(mapper) }.observeOn(UIScheduler())
    }
    
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

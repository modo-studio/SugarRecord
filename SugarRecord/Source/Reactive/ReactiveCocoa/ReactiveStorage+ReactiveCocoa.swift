import Foundation
import ReactiveCocoa
import Result

public extension Storage {
    
    // MARK: - Operation
    
    func rac_operation<T>(op: (context: Context, save: () -> Void) throws -> T) -> SignalProducer<T, Error> {
        return SignalProducer { (observer, disposable) in
            do {
                let returnedObject = try self.operation { (context, saver) throws in
                    try op(context: context, save: {
                        saver()
                    })
                }
                
                observer.sendNext(returnedObject)
                observer.sendCompleted()
            }
            catch {
                observer.sendFailed(Error.Store(error))
            }
        }
    }
    
    func rac_operation<T>(op: (context: Context) throws -> T) -> SignalProducer<T, Error> {
        return self.rac_operation { (context, saver) throws in
            let returnedObject = try op(context: context)
            saver()
            return returnedObject
        }
    }
    
    func rac_backgroundOperation<T>(op: (context: Context, save: () -> Void) throws -> T) -> SignalProducer<T, Error> {
        return SignalProducer { (observer, disposable) in
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                do {
                    let returnedObject = try self.operation { (context, saver) throws in
                        try op(context: context, save: {
                            saver()
                        })
                    }
                    observer.sendNext(returnedObject)
                    observer.sendCompleted()
                }
                catch {
                    observer.sendFailed(Error.Store(error))
                }
            }
        }
    }
    
    func rac_backgroundOperation<T>(op: (context: Context) throws -> T) -> SignalProducer<T, Error> {
        return rac_backgroundOperation { (context, save) throws in
            let returnedObject = try op(context: context)
            save()
            
            return returnedObject
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

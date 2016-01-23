import Foundation
import RxSwift

public extension ReactiveStorage where Self: Storage {

    /**
     Executes the given operation.
     
     - parameter operation: Operation to be executed. Context must be used to save your changes in and the save() closure must be called in order to get the changes persisted in the storage.
     
     - returns: Observable that executes the action.
     */
    func rx_operation(op: (context: Context, save: Saver) -> Void) -> Observable<Void> {
        return Observable.create({ (observer) -> RxSwift.Disposable in
            self.operation({ (context, saver) -> Void in
                op(context: context, save: saver)
                observer.onCompleted()
            })
            return NopDisposable.instance
        })
    }
    
    /**
     Executes the given operation in a background thread.
     
     - parameter operation: Operation to be executed. Context must be used to save your changes in and the save() closure must be called in order to get the changes persisted in the storage.
     
     - returns: Observable that executes the action.
     */
    func rx_backgroundOperation(op: (context: Context, save: Saver) -> Void) -> Observable<Void> {
        return Observable.create { (observer) -> RxSwift.Disposable in
            self.operation { (context, saver) in
                op(context: context, save: saver)
                observer.onCompleted()
            }
            return NopDisposable.instance
        }
    }
    
    /**
     Executes a background fetch mapping the response into a PONSO thread safe entity.
     
     - parameter request: Request to be executed.
     - parameter mapper:  Mapper.
     
     - returns: Observable that executes the action.
     */
    func rx_backgroundFetch<T, U>(request: Request<T>, mapper: T -> U) -> Observable<[U]> {
        let observable: Observable<[T]> = Observable.create({ (observer) -> RxSwift.Disposable in
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                do {
                    let results = try self.saveContext.fetch(request)
                    observer.onNext(results)
                    observer.onCompleted()
                }
                catch {
                    if let error = error as? Error {
                        observer.onError(error)
                    }
                    else {
                        observer.onNext([])
                        observer.onCompleted()
                    }
                }
            }
            return NopDisposable.instance
        })
        return observable.map({$0.map(mapper)}).observeOn(MainScheduler.instance)
    }

    /**
     Executes a request.
     
     - parameter request: Request to be executed.
     
     - returns: Observable that executes the action.
     */
    func rx_fetch<T>(request: Request<T>) -> Observable<[T]> {
        return Observable.create({ (observer) -> RxSwift.Disposable in
            do {
                try observer.onNext(self.fetch(request))
                observer.onCompleted()
            }
            catch  {
                if let error = error as? Error {
                    observer.onError(error)
                }
                else {
                    observer.onNext([])
                    observer.onCompleted()
                }
            }
            return NopDisposable.instance
        })
    }
    
}
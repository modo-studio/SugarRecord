import Foundation
import RxSwift

public extension Storage {

    func rx_operation(op: (context: Context, save: () -> Void) throws -> Void) -> RxSwift.Observable<Void> {
        return RxSwift.Observable.create { (observer) -> RxSwift.Disposable in
            do {
                try self.operation { (context, saver) throws -> Void in
                    try op(context: context, save: { () -> Void in
                        saver()
                    })
                    observer.onCompleted()
                }
            }
            catch {
                observer.onError(error)
            }
            return NopDisposable.instance
        }
    }
    
    func rx_operation(op: (context: Context) -> Void) -> RxSwift.Observable<Void> {
        return rx_operation { (context, save) in
            op(context: context)
            save()
        }
    }
    
    func rx_backgroundOperation(op: (context: Context, save: () -> Void) throws -> Void) -> RxSwift.Observable<Void> {
        return RxSwift.Observable.create { (observer) -> RxSwift.Disposable in
            do {
                try self.operation { (context, saver) throws in
                    try op(context: context, save: { () -> Void in
                        saver()
                    })
                    observer.onCompleted()
                }
            }
            catch {
                observer.onError(error)
            }
            return NopDisposable.instance
        }
    }
    
    /**
     Create a background operation that you can return an object id or some other thread safe element to use in the chain
     
     Example : 
     
     let createOb: Observable<String> = storage.rx_backgroundOperation({ (context, save) in {
        
        ... database work
     
        save()
        
        return stringID
     }
     
     createOb.subscribeNext({ (objectId) in {
     
        .. do something with new objectId
     
     }).addDisposableTo(self.disposeBag)
     
     - parameter op: The operation that you wish to execute
     
     - returns: Returns an Observable of the type specififed
     */
    func rx_backgroundCreateOperation<T>(op: (context: Context, save: () -> Void) throws -> T) -> Observable<T> {
        return Observable.create { (observer) -> RxSwift.Disposable in
            do {
                try self.operation { (context, saver) throws in
                    let returnedObject = try op(context: context, save: { () -> Void in
                        saver()
                    })
                    observer.onNext(returnedObject)
                    observer.onCompleted()
                }
            }
            catch {
                observer.onError(error)
            }
            return NopDisposable.instance
        }
    }
    
    func rx_backgroundOperation(op: (context: Context) throws -> Void) -> RxSwift.Observable<Void> {
        return rx_backgroundOperation { (context, save) throws in
            try op(context: context)
            save()
        }
    }
    
    func rx_backgroundFetch<T, U>(request: Request<T>, mapper: T -> U) -> RxSwift.Observable<[U]> {
        let observable: RxSwift.Observable<[T]> = RxSwift.Observable.create { (observer) -> RxSwift.Disposable in
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
        }
        return observable
            .map { $0.map(mapper) }
            .observeOn(MainScheduler.instance)
    }

    func rx_fetch<T>(request: Request<T>) -> RxSwift.Observable<[T]> {
        return RxSwift.Observable.create { (observer) -> RxSwift.Disposable in
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
        }
    }
    
}

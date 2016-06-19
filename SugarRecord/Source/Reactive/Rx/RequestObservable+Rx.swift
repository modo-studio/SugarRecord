import Foundation
import RxSwift

public extension RequestObservable {
    
    public func rx_observe() -> Observable<ObservableChange<T>> {
        return Observable.create { (observer) -> Disposable in
            self.observe { change in
                observer.onNext(change)
            }
            return AnonymousDisposable {
                self.dispose()
                observer.onCompleted()
            }
        }
    }
    
}

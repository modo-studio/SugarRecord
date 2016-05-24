import Foundation
import RxSwift

public extension Observable {
    
    public func rx_observe() -> RxSwift.Observable<ObservableChange<T>> {
        return RxSwift.Observable.create { (observer) -> Disposable in
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

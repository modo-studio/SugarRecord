import Foundation
import ReactiveCocoa
import Result

public extension RequestObservable {
    
    public func rac_observe() -> SignalProducer<ObservableChange<T>, NoError> {
        return SignalProducer { (observer, disposable) in
            self.observe { change in
                observer.sendNext(change)
            }
            disposable.addDisposable {
                self.dispose()
                observer.sendCompleted()
            }
        }
    }
    
}

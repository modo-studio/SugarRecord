import Foundation
import ReactiveCocoa

public protocol Context {
    func fetch<T>(request: Request<T>) -> SignalProducer<[T], NoError>
    func add<T>(objects: [T]) -> SignalProducer<Void, NoError>
    func remove<T>(objects: [T]) -> SignalProducer<Void, NoError>
}
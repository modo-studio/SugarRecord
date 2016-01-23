import Foundation

/**
 *  Protol that defines the Reactive interface of an Storage
 */
public protocol ReactiveStorage {
    typealias Saver = () -> Void
}

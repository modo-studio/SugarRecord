import Foundation

public protocol ReactiveStorage {
    associatedtype Saver = () -> Void
}

import Foundation
import ReactiveCocoa

/**
 *  Protocol that defines the Reactive interface of a Context
 */
public protocol ReactiveContext {
    
}

extension ReactiveContext where Self: Context {
    
}


/*
func fetch<T: Entity>(request: Request<T>) -> Result<[T], Error>
func insert<T: Entity>() -> Result<T, Error>
func remove<T: Entity>(objects: [T]) -> Result<Void, Error>
*/
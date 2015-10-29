import Foundation
import CoreData
import ReactiveCocoa

extension NSManagedObjectContext: Context {
    
    public func rac_fetch<T: Entity>(request: Request<T>) -> SignalProducer<[T], Error> {
        return SignalProducer.empty
        //TODO
    }
    func fetch<T: Entity>(request: Request<T>) -> (results: [T], error: Error?) {
        //TODO
        return ([], nil)
    }
    
    public func insert<T: Entity>() -> SignalProducer<T, Error> {
        if let object = NSEntityDescription.insertNewObjectForEntityForName(T.entityName, inManagedObjectContext: self) as? T {
            return SignalProducer(value: object)
        }
        else {
            return SignalProducer(error: .InvalidType)
        }
    }
    
    public func remove<T: Entity>(objects: [T]) -> SignalProducer<Void, Error> {
        for object in objects {
            guard let _object = object as? NSManagedObject else { continue }
            self.deleteObject(_object)
        }
        return SignalProducer.empty
    }
}
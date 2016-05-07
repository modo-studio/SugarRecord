//import Foundation
//import CoreData
//
//public class CoreDataObservable<T: NSManagedObject>: Observable<T>, NSFetchedResultsControllerDelegate {
//    
//    // MARK: - Attributes
//    
//    internal let fetchedResultsController: NSFetchedResultsController
//    internal let fetchRequest: NSFetchRequest
//    internal var observer: (ObservableChange<[T]> -> Void)?
//    private var batchChanges: [CoreDataChange<T>] = []
//
//    
//    // MARK: - Init
//    
//    public init(request: Request<T>, context: NSManagedObjectContext) {
//        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: T.entityName)
//        if let predicate = request.predicate {
//            fetchRequest.predicate = predicate
//        }
//        if let sortDescriptor = request.sortDescriptor {
//            fetchRequest.sortDescriptors = [sortDescriptor]
//        }
//        self.fetchRequest = fetchRequest
//        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        super.init(request: request)
//        self.fetchedResultsController.delegate = self
//    }
//    
//    
//    // MARK: - Observable
//    
//    public override func observe(closure: ObservableChange<[T]> -> Void) {
//        assert(self.observer != nil, "Observable can be observed only once")
//        let initial = try! self.fetchedResultsController.managedObjectContext.executeFetchRequest(self.fetchRequest) as! [T]
//        closure(ObservableChange.Initial(initial))
//        self.observer = closure
//    }
//    
//    // MARK: - NSFetchedResultsControllerDelegate
//    
//    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        switch type {
//        case .Delete:
//            self.batchChanges.append(.Delete(anObject as! T))
//        case .Insert:
//            self.batchChanges.append(.Insert(anObject as! T))
//        case .Update:
//            self.batchChanges.append(.Update(anObject as! T))
//        default: break
//        }
//    }
//    
//    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        self.batchChanges = []
//    }
//    
//    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        let objects = self.batchChanges.map {$0.object()}
//        let deleted = self.batchChanges.filterAndMapIndex { $0.isDeletion() }
//        let inserted = self.batchChanges.filterAndMapIndex { $0.isInsertion() }
//        let updated = self.batchChanges.filterAndMapIndex { $0.isUpdate() }
//        self.observer?(ObservableChange.Update(objects, deletions: deleted, insertions: inserted, modifications: updated))
//    }
//
//    
//    // MARK: - Deinit
//    
//    deinit {
//        self.fetchedResultsController.delegate = nil
//        self.observer = nil
//    }
//    
//}

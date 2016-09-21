import Foundation
import CoreData
#if os(iOS) || os(tvOS) || os(watchOS)

public class CoreDataObservable<T: NSManagedObject>: RequestObservable<T>, NSFetchedResultsControllerDelegate where T:Equatable {

    // MARK: - Attributes

    internal let fetchRequest: NSFetchRequest<NSFetchRequestResult>
    internal var observer: ((ObservableChange<T>) -> Void)?
    internal let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    private var batchChanges: [CoreDataChange<T>] = []


    // MARK: - Init

    internal init(request: FetchRequest<T>, context: NSManagedObjectContext) {

        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        if let predicate = request.predicate {
            fetchRequest.predicate = predicate
        }
        if let sortDescriptor = request.sortDescriptor {
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        fetchRequest.fetchBatchSize = 0
        self.fetchRequest = fetchRequest
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init(request: request)
        self.fetchedResultsController.delegate = self
    }


    // MARK: - Observable

    public override func observe(_ closure: @escaping (ObservableChange<T>) -> Void) {
        assert(self.observer == nil, "Observable can be observed only once")
        let initial = try! self.fetchedResultsController.managedObjectContext.fetch(self.fetchRequest) as! [T]
        closure(ObservableChange.initial(initial))
        self.observer = closure
        _ = try? self.fetchedResultsController.performFetch()
    }


    // MARK: - Dipose Method
    
    override func dispose() {
        self.fetchedResultsController.delegate = nil
    }


    // MARK: - NSFetchedResultsControllerDelegate

    @nonobjc public func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeObject anObject: AnyObject, atIndexPath indexPath: IndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            self.batchChanges.append(.delete(indexPath![0], anObject as! T))
        case .insert:
            self.batchChanges.append(.insert(newIndexPath![0], anObject as! T))
        case .update:
            self.batchChanges.append(.update(indexPath![0], anObject as! T))
        default: break
        }
    }

    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.batchChanges = []
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let deleted = self.batchChanges.filter { $0.isDeletion }.map { $0.index() }
        let inserted = self.batchChanges.filter { $0.isInsertion }.map { (index: $0.index(), element: $0.object()) }
        let updated = self.batchChanges.filter { $0.isUpdate }.map { (index: $0.index(), element: $0.object()) }
        self.observer?(ObservableChange.update(deletions: deleted, insertions: inserted, modifications: updated))
    }

}
#endif

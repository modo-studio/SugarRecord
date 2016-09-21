import Foundation
import RealmSwift

open class RealmObservable<T: Object>: RequestObservable<T> {
    
    // MARK: - Attributes
    
    internal let realm: Realm
    internal var notificationToken: NotificationToken?
    
    
    // MARK: - Init
    
    internal init(request: FetchRequest<T>, realm: Realm) {
        self.realm = realm
        super.init(request: request)
    }
    
    
    // MARK: - Observable
    
    open override func observe(_ closure: @escaping (ObservableChange<T>) -> Void) {
        assert(self.notificationToken == nil, "Observable can be observed only once")
        var realmObjects = self.realm.objects(T.self)
        if let predicate = self.request.predicate {
            realmObjects = realmObjects.filter(predicate)
        }
        if let sortDescriptor = self.request.sortDescriptor {
            realmObjects = realmObjects.sorted(byProperty: sortDescriptor.key!, ascending: sortDescriptor.ascending)
        }
        self.notificationToken = realmObjects.addNotificationBlock { (changes: RealmCollectionChange<Results<T>>) in
            closure(self.map(changes))
        }
    }
    
    override func dispose() {
        self.notificationToken = nil
    }
    
    
    // MARK: - Private
    
    fileprivate func map(_ realmChange: RealmCollectionChange<Results<T>>) -> ObservableChange<T> {
        switch realmChange {
        case .error(let error):
            return ObservableChange.error(error)
        case .initial(let initial):
            return ObservableChange.initial(initial.toArray())
        case .update(let objects, let deletions, let insertions, let modifications):
            let deletions = deletions.map { $0 }
            let insertions = insertions.map { (index: $0, element: objects[$0]) }
            let modifications = modifications.map { (index: $0, element: objects[$0]) }
            return ObservableChange.update(deletions: deletions, insertions: insertions, modifications: modifications)
        }
    }
    
}

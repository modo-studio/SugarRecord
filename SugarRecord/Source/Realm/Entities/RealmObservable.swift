import Foundation
import RealmSwift

public class RealmObservable<T: Object>: RequestObservable<T> {
    
    // MARK: - Attributes
    
    internal let realm: Realm
    internal var notificationToken: NotificationToken?
    
    
    // MARK: - Init
    
    internal init(request: Request<T>, realm: Realm) {
        self.realm = realm
        super.init(request: request)
    }
    
    
    // MARK: - Observable
    
    public override func observe(closure: ObservableChange<T> -> Void) {
        assert(self.notificationToken == nil, "Observable can be observed only once")
        var realmObjects = self.realm.objects(T)
        if let predicate = self.request.predicate {
            realmObjects = realmObjects.filter(predicate)
        }
        if let sortDescriptor = self.request.sortDescriptor {
            realmObjects = realmObjects.sorted(sortDescriptor.key!, ascending: sortDescriptor.ascending)
        }
        self.notificationToken = realmObjects.addNotificationBlock { (changes: RealmCollectionChange<Results<T>>) in
            closure(self.map(changes))
        }
    }
    
    override func dispose() {
        self.notificationToken = nil
    }
    
    
    // MARK: - Private
    
    private func map(realmChange: RealmCollectionChange<Results<T>>) -> ObservableChange<T> {
        switch realmChange {
        case .Error(let error):
            return ObservableChange.Error(error)
        case .Initial(let initial):
            return ObservableChange.Initial(initial.toArray())
        case .Update(let objects, let deletions, let insertions, let modifications):
            let deletions = deletions.map { $0 }
            let insertions = insertions.map { (index: $0, element: objects[$0]) }
            let modifications = modifications.map { (index: $0, element: objects[$0]) }
            return ObservableChange.Update(deletions: deletions, insertions: insertions, modifications: modifications)
        }
    }
    
}

With everything setup we're ready to start working with our database models. The main  advantage of using SugarRecord  is its fresh and sugar syntax that allows you to do operations that whould take more than one line in CoreData/Realm in just one human-readable line.

The basic operations we can do with dataase models are: creation, edition, deletion and querying.

## Transactions

Operations like edition/deletion/creation **MUST** be grouped in a transaction. The way to group different operations into a single trasaction is using the following methods of the SugarRecordContext:

```swift
context.beginWriting()
context.endWriting()
```
**It's very important to notify the context when you are going to execute any of these kind of operations**, otherwise the app might crash. Moreover, remember that the changes are persisted once you call `endWriting()`, otherwise they will be in your object but not in the database.

*Note: If you want to cancel a transaction and return everything to the previous status you can do it using the `cancelWriting()* method.


## Objects creation

ManagedObjects and RLMObjects have extensions to make the creation easier. Methods included there are connected with SugarRecord and the stacks you previously setup. The example below shows the creation of an user without mattering if it's a RLMObject OR A CoreData object
```swift
var user: User = User.create() as User
user.name = "Pepito"
user.age = 21
let saved: Bool = user.save()
```
**Note:** * what `save()` method actually does it o save the context **where** the object is alive

#TODO: If the user saves  n times it will be saved n times , defensive code has to be added here.

### Objects edition

To edit your objects you have to notify SugarRecord that you are going to start/end an edition. If you are going to edit only one object you can do it quickly with the methods `beginWriting()` and `endWriting() `. It's very important to tell SugarRecord about any edition or you app might crash. Take a look to the example below

```swift
user.beginWriting()
user.name = "Pepito"
user.age++
user.endWriting()
```
**Note:** `beginWriting()` and `endWriting()` notify the context where the object is alive about modifications. In case of Realm `beginWriting()` notification is specially critical forgetting it causes a crash of the app.

### Objects deletion

If you want to delete an object that you have in a SugarRecord context you can do it easily using the method `delete()`. **It's very important** to call `beginWriting()` and `endWriting()` here too to notify the library about the changes you are making. Take a look to the examples below:

```swift
// 3-Lines syntax
user.beginWriting()
user.delete()
user.endWriting()

// 1-Line syntax
user.beginWriting().delete().endWriting()
```

### Objects querying

Fetching elements had never been so easy as it's now with SugarRecord. Take a look to the examples below because they are self-explaining:

```swift
let users: [User]? = User.sorted(by:"name", ascending: true).firsts(10).find()?
users: User? = User().find()?.first as User?
users: [User]? = User("age", equalTo: "10").sorted(by:"name", ascending: true).find() as [User]?
users: [User]? = User.all().find() as [User]?
```
The example above is valid for **Realm** and **Objective-C**. Available querying options are:

```swift
public func by(predicate: NSPredicate) -> SugarRecordFinder {}
public func by(predicateString: NSString) -> SugarRecordFinder {}
public func by(key: String, equalTo value: String) -> SugarRecordFinder {}
public func sorted(by sortingKey: String, ascending: Bool) -> SugarRecordFinder {}
public func sorted(by sortDescriptor: NSSortDescriptor) -> SugarRecordFinder {}
public func sorted(by sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder {}
public func all() -> SugarRecordFinder {}
public func first() -> SugarRecordFinder {}
public func last() -> SugarRecordFinder {}
public func firsts(number: Int) -> SugarRecordFinder {}
public func lasts(number: Int) -> SugarRecordFinder {}
public func count() -> Int {}
```

Filtering and sortering methods can be concatenated and finally fetched using `find()`

### FetchedResultsController (CoreData only)

Previous filtering method can be finally  translated into an array of results using the `find()` method. However if you want to connect those results and listein their changes using a NSFetchedResultsController you have a method:

```swift
public func fetchedResultsController(section: String?, cacheName: String?) -> NSFetchedResultsController
```

That returns the  NSFetchedResultsController with your Queryng predicates and sort descriptors:

```swift
let frc: NSFetchedResultsController = User("age", equalTo: "10").fetchedResultsController("city", nil)
```
**Note:** *Do not use this with Realm objects because it's a feature only available for CoreData



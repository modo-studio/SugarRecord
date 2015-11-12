Concepts
============

## Storage

A **storage** represents a database setup configuration. Thinking about CoreData it represents the persistent store, coordinator, and all the context needed for operations. In case of Realm it's much simpler, just a Realm. SugarRecord defines Storage as a protocol whose interface is shown below:

```swift
var type: StorageType { get } // .Realm / .CoreData
var mainContext: Context! { get }
var saveContext: Context! { get }
var memoryContext: Context! { get }
func removeStore() throws
func operation(operation: (context: Context, save: Saver) -> Void, completed: (() -> Void)?)
func operation(queue queue: Queue, operation: (context: Context, save: Saver) -> Void, completed: (() -> Void)?)
```

- **mainContext:** Context for operations in the main thread. Use it for fetching models to be used in the presentation layer
- **saveContext:** Context used for high load operations like persisting data received from an API.
- **memoryContext:** Not persisted context, very useful for testing.
- **removeStore:** Removes the local store.
- **operation:** Define operation blocks and pass them to this function. You can use it for high load operations.

### CoreData
#### CoreDataDefaultStorage

### Realm
#### RealmDefaultStorage

### Build your own Storage
In case the existing storages are not enough for you or you need a different configuration we encourage you to implement your own and propose it to the library. We're opened to help you and included them in the library. *Examples of storages could be for example a CoreData storage with iCloud, Dropbox Storage, ...*

Here you have a document with some tips for designing your [storage](design.md)

## Context


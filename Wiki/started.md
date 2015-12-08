Getting started
============

## Storage

### CoreData

Create an instance of the `CoreDataDefaultStorage`

```swift
let storage =  try! CoreDataDefaultStorage(store: .Named("mydb.sqlite"), model: .Merged(nil), migrate: true)
```

### Realm

Create an instance of the `RealmDefaultStorage`

```swift
let storage =  try! RealmDefaultStorage()
```

## Fetching
You can fetch models directly using the available interface around models like the examples shown below:

```swift
let person = Person.filteredWith("name", equalTo: "pedro").inStorage(storage).value.first
let people = Person.sortedBy(sortDescriptor: NSSortDescriptor(key: "name": ascending: true)).value
```

You can check all the available methods in the library [**reference**](http://blog.gitdo.io/SugarRecord/). Look for `Requestable` protocol and `Request` struct components.

> If you think would be great to add another method to that interface drop me a line, [pedro@gitdo.io](mailto://pedro@gitdo.io), the idea is evolve it according to the developers needs.

**Notes**
- Fetch results are returned as a generic type `Result<[T], Error>` that wraps the fetching result and the error. If you want to unwrap the error or the value you can use its properties `value` and `error` respectively as shown above.
- The returned value is always an array, in case you expect one value, use the first element of that array. Keep in mind that that value is an optional and might be nil.

## Saving/Deleting

Saving and deleting operation must be executed using the operation method of your storage. Its use is very simple as show below:

```swift
storage?.operation({ (context, save) -> Void in
    for apiIssue in apiIssues {
      let issue: Issue! = context.insert().value
      issue.identifier = apiIssue.identifier
      issue.name = apiIssue.name
    }
    save()
}, completed: { () -> Void in
    // YAI!
})
```
1. When the method is called you pass an operation. An operation is a closure with a `context` as an `save` as input parameters:
  - **Context:** It's the entry point to your storage. It defines `insert/delete/fetch` methods.
  - **Save:** It's a closure that you have to call if you want to persist your changes. Otherwise your changes won't be persisted.
2. Then the operation is completed the storage calls your `completed` closure in case you need to do something after these operations complete. 
